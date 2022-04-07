require 'spec_helper'

describe 'rabbitmq_policy' do
  step_into :rabbitmq_policy

  platform 'ubuntu'

  context 'when policies do not exist' do
    before do
      shellout = double
      allow(Mixlib::ShellOut).to receive(:new).with(
        /rabbitmqctl list_policies/, { env: { 'HOME' => // } }
      ).and_return(shellout)
      allow(shellout).to receive(:run_command).and_return(shellout)
      allow(shellout).to receive(:stdout).and_return('[]')
    end

    recipe do
      rabbitmq_policy 'potato' do
        pattern '^(?!amq\\.).*'
        definition(
          'ha-mode' => 'exactly',
          'ha-params' => 2,
          'ha-sync-mode' => 'automatic'
        )
        action :set
      end

      rabbitmq_policy 'tomato' do
        action :clear
      end
    end

    it 'sets the policy' do
      is_expected.to run_execute('set_policy potato on vhost /').with(
        command: 'rabbitmqctl -q set_policy -p / --apply-to all potato "^(?!amq\\.).*" '\
                '\'{"ha-mode":"exactly","ha-params":2,"ha-sync-mode":"automatic"}\' --priority 0'
      )
      is_expected.to_not run_execute('clear_policy tomato from vhost /')
    end
  end

  context 'when policies already exist' do
    before do
      shellout = double
      allow(Mixlib::ShellOut).to receive(:new).with(
        /rabbitmqctl list_policies/, { env: { 'HOME' => // } }
      ).and_return(shellout)
      allow(shellout).to receive(:run_command).and_return(shellout)
      allow(shellout).to receive(:stdout).and_return(
        '[
          {
            "name":"policy1",
            "pattern":"pattern1",
            "definition":{"key1":"val1"},
            "apply-to":"all",
            "priority":0
          },
          {
            "name":"policy2",
            "pattern":"pattern2",
            "definition":{"key2":"val2"},
            "apply-to":"queues",
            "priority":1
          },
          {
            "name":"policy3",
            "pattern":"pattern3",
            "definition":{"key3":"val3"},
            "apply-to":"queues",
            "priority":2
          }
        ]'
      )
    end

    recipe do
      rabbitmq_policy 'policy1' do
        pattern 'pattern1'
        definition('key1' => 'val1', 'extrakey' => 'extraval')
        apply_to 'all'
        priority 0
        action :set
      end

      rabbitmq_policy 'policy2' do
        pattern 'pattern2'
        definition('key2' => 'val2')
        apply_to 'queues'
        priority 1
        action :set
      end

      rabbitmq_policy 'policy3' do
        action :clear
      end
    end

    it 'amends only the policies that have changed' do
      is_expected.to run_execute('set_policy policy1 on vhost /').with(
        command: 'rabbitmqctl -q set_policy -p / --apply-to all policy1 "pattern1" '\
                '\'{"key1":"val1","extrakey":"extraval"}\' --priority 0'
      )
      is_expected.to_not run_execute('set_policy policy2 on vhost /')
      is_expected.to run_execute('clear_policy policy3 from vhost /')
    end
  end
end
