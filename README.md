# rabbitmq Cookbook

[![Build Status](https://travis-ci.org/rabbitmq/chef-cookbook.svg?branch=master)](https://travis-ci.org/rabbitmq/chef-cookbook)
[![Cookbook Version](https://img.shields.io/cookbook/v/rabbitmq.svg)](https://supermarket.chef.io/cookbooks/rabbitmq)

This is a cookbook for managing RabbitMQ with Chef. It is intended for RabbitMQ 2.6.1 or later releases and Chef 12.1 and later.

**NOTE**: This cookbook is still maintained by @jjasghar, please ping him on PRs or Issues you may find.

## Requirements

This cookbook depends on the [erlang cookbook](https://supermarket.chef.io/cookbooks/erlang).

The release was tested with (rabbitmq.com/distro version), from the [kitchen.yml](.kitchen.cloud.yml).

- CentOS 7.0
- Ubuntu 14.04
- Ubuntu 16.04
- Debian 8.0

We are starting to test with Ubuntu 16.04, though we have not fully vetted support yet.
Use at your own risk, if you do find something please report [here](https://github.com/jjasghar/rabbitmq/issues/379).

## Recipes

### default
Installs `rabbitmq-server` from RabbitMQ.com via direct download of the installation package or using the distribution version. Depending on your distribution, the provided version may be quite old so they are disabled by default. If you want to use the distro version, set the attribute `['rabbitmq']['use_distro_version']` to `true`. You may override the download URL attribute `['rabbitmq']['package']` if you wish to use a local mirror.

The cluster recipe is now combined with the default and will now auto-cluster. Set the `['rabbitmq']['clustering']['enable']` attribute to `true`, `['rabbitmq']['clustering']['cluster_disk_nodes']` array of `node@host` strings that describe which you want to be disk nodes and then set an alphanumeric string for the `erlang_cookie`.

To enable SSL turn `ssl` to `true` and set the paths to your cacert, cert and key files.
```ruby
node['rabbitmq']['ssl'] = true
node['rabbitmq']['ssl_cacert'] = '/path/to/cacert.pem'
node['rabbitmq']['ssl_cert'] = '/path/to/cert.pem'
node['rabbitmq']['ssl_key'] = '/path/to/key.pem'
```

A full list of SSL attributes can be found in [attributes/default.rb](attributes/default.rb).

#### Attributes

Default values and usage information of important attributes are shown below.  More attributes are documented in metadata.rb.

##### Username and Password

The default username and password are guest/guest:

`['rabbitmq']['default_user'] = 'guest'`

`['rabbitmq']['default_pass'] = 'guest'`

##### Loopback Users
By default, the guest user can only connect via localhost.  This is the behavior of RabbitMQ when the loopback_users configuration is not specified in it's configuration file.   Also, by default, this cookbook does not specify loopback_users in the configuration file:

`['rabbitmq']['loopback_users'] = nil`

If you wish to allow the default guest user to connect remotely, you can change this to `[]`. If instead you wanted to allow just the user 'foo' to connect over loopback, you would set this value to `["foo"]`.  More information can be found here: https://www.rabbitmq.com/access-control.html.



### mgmt_console
Installs the `rabbitmq_management` and `rabbitmq_management_visualiser` plugins.
To use https connection to management console, turn `['rabbitmq']['web_console_ssl']` to true. The SSL port for web management console can be configured by setting attribute `['rabbitmq']['web_console_ssl_port']`, whose default value is 15671.

### plugin_management
Enables any plugins listed in the `node['rabbitmq']['enabled_plugins']` and disables any listed in `node['rabbitmq']['disabled_plugins']` attributes.

### community_plugins
Downloads, installs and enables pre-built community plugins binaries.

To specify a plugin, set the attribute `node['rabbitmq']['community_plugins']['PLUGIN_NAME']` to `'DOWNLOAD_URL'`. For example, to use the [RabbitMQ priority queue plugin](https://github.com/rabbitmq/rabbitmq-priority-queue), set the attribute `node['rabbitmq']['community_plugins']['rabbitmq_priority_queue']` to `'https://www.rabbitmq.com/community-plugins/v3.4.x/rabbitmq_priority_queue-3.4.x-3431dc1e.ez'`.

### policy_management
Enables any policies listed in the `node['rabbitmq']['policies']` and disables any listed in `node['rabbitmq']['disabled_policies']` attributes.

See examples in attributes file.

### user_management
Enables any users listed in the `node['rabbitmq']['enabled_users']` and disables any listed in `node['rabbitmq']['disabled_users']` attributes.
You can provide user credentials, the vhosts that they need to have access to and the permissions that should be allocated to each user.

```ruby
node['rabbitmq']['enabled_users'] = [
    {
        :name => 'kitten',
        :password => 'kitten',
        :tag => 'leader',
        :rights => [
            {
                :vhost => 'nova',
                :conf => '.*',
                :write => '.*',
                :read => '.*'
            }
        ]
    }
]
```

### virtualhost_management
Enables any vhosts listed in the `node['rabbitmq']['virtualhosts']` and disables any listed in `node['rabbitmq']['disabled_virtualhosts']` attributes.

### cluster
Configure the cluster between the nodes in the `node['rabbitmq']['clustering']['cluster_nodes']` attribute. It also, supports the auto or manual clustering.
* Auto clustering : Use auto-configuration of RabbitMQ, http://www.rabbitmq.com/clustering.html#auto-config
* Manual clustering : Configure the cluster by executing `rabbitmqctl join_cluster` command.

#### Attributes that related to clustering
* `node['rabbitmq']['clustering']['enable']` : Default decision flag of clustering
* `node['rabbitmq']['erlang_cookie']` : Same erlang cookie is required for the cluster
* `node['rabbitmq']['clustering']['use_auto_clustering']` : Default is false. (manual clustering is default)
* `node['rabbitmq']['clustering']['cluster_name']` : Name of cluster. default value is nil. In case of nil or '' is set for `cluster_name`, first node name in `node['rabbitmq']['clustering']['cluster_nodes']` attribute will be set for manual clustering. for the auto clustering, one of the node name will be set.
* `node['rabbitmq']['clustering']['cluster_nodes']` : List of cluster nodes. it required node name and cluster node type. please refer to example in below.

Attributes example
```ruby
node['rabbitmq']['clustering']['enable'] = true
node['rabbitmq']['erlang_cookie'] = 'AnyAlphaNumericStringWillDo'
node['rabbitmq']['clustering']['cluster_partition_handling'] = 'ignore'
node['rabbitmq']['clustering']['use_auto_clustering'] = false
node['rabbitmq']['clustering']['cluster_name'] = 'seoul_tokyo_newyork'
node['rabbitmq']['clustering']['cluster_nodes'] = [
    {
        :name => 'rabbit@rabbit1',
        :type => 'disc'
    },
    {
        :name => 'rabbit@rabbit2',
        :type => 'ram'
    },
    {
        :name => 'rabbit@rabbit3',
        :type => 'disc'
    }
]
```

## Resources/Providers

There are 5 LWRPs for interacting with RabbitMQ.

### plugin
Enables or disables a rabbitmq plugin. Plugins are not supported for releases prior to 2.7.0.

- `:enable` enables a `plugin`
- `:disable` disables a `plugin`

#### Examples
```ruby
rabbitmq_plugin "rabbitmq_stomp" do
  action :enable
end
```

```ruby
rabbitmq_plugin "rabbitmq_shovel" do
  action :disable
end
```

### policy
sets or clears a rabbitmq policy.

- `:set` sets a `policy`
- `:clear` clears a `policy`
- `:list` lists `policy`s

#### Examples
```ruby
rabbitmq_policy "ha-all" do
  pattern "^(?!amq\\.).*"
  parameters ({"ha-mode"=>"all"})
  priority 1
  action :set
end
```

```ruby
rabbitmq_policy "ha-all" do
  action :clear
end
```

### user
Adds and deletes users, fairly simplistic permissions management.

- `:add` adds a `user` with a `password`
- `:delete` deletes a `user`
- `:set_permissions` sets the `permissions` for a `user`, `vhost` is optional
- `:clear_permissions` clears the permissions for a `user`
- `:set_tags` set the tags on a user
- `:clear_tags` clear any tags on a user
- `:change_password` set the `password` for a `user`

#### Examples
```ruby
rabbitmq_user "guest" do
  action :delete
end
```

```ruby
rabbitmq_user "nova" do
  password "sekret"
  action :add
end
```

```ruby
rabbitmq_user "nova" do
  vhost "/nova"
  permissions ".* .* .*"
  action :set_permissions
end
```

```ruby
rabbitmq_user "rmq" do
  vhost ["/", "/rmq", "/nova"]
  permissions ".* .* .*"
  action :set_permissions
end
```

```ruby
rabbitmq_user "joe" do
  tag "admin,lead"
  action :set_tags
end
```

### vhost
Adds and deletes vhosts.

- `:add` adds a `vhost`
- `:delete` deletes a `vhost`

#### Examples
``` ruby
rabbitmq_vhost "/nova" do
  action :add
end
```

### cluster
Join cluster, set cluster name and change cluster node type.

- `:join` join in cluster as a manual clustering. node will join in first node of json string data.

 - cluster nodes data json format : Data should have all the cluster nodes information.

 ```
 [
     {
         "name" : "rabbit@rabbit1",
         "type" : "disc"
     },
     {
         "name" : "rabbit@rabbit2",
         "type" : "ram"
     },
     {
         "name" "rabbit@rabbit3",
         "type" : "disc"
     }
]
 ```

- `:set_cluster_name` set the cluster name.
- `:change_cluster_node_type` change cluster type of node. `disc` or `ram` should be set.

#### Examples
```ruby
rabbitmq_cluster '[{"name":"rabbit@rabbit1","type":"disc"},{"name":"rabbit@rabbit2","type":"ram"},{"name":"rabbit@rabbit3","type":"disc"}]' do
  action :join
end
```

```ruby
rabbitmq_cluster '[{"name":"rabbit@rabbit1","type":"disc"},{"name":"rabbit@rabbit2","type":"ram"},{"name":"rabbit@rabbit3","type":"disc"}]' do
  cluster_name 'seoul_tokyo_newyork'
  action :set_cluster_name
end
```

```ruby
rabbitmq_cluster '[{"name":"rabbit@rabbit1","type":"disc"},{"name":"rabbit@rabbit2","type":"ram"},{"name":"rabbit@rabbit3","type":"disc"}]' do
  action :change_cluster_node_type
end
```

#### Removing nodes from cluster

This cookbook provides the primitives to remove a node from a cluster via helper functions but do not include these in any recipes. This is something that is potentially very dangerous and different deployments will have different needs and IF you decide you need this it should be implemented in your wrapper with EXTREME caution. There are 2 helper methods for 2 different scenario:
- removing self from cluster. This should likely only be considered for machines on a normal decommission. This is accomplished by using the helper fucntion `reset_current_node`.
- removing another node from cluster. This should only be done once you are sure the machine is gone and won't come back. This can be accomplished via `remove_remote_node_from_cluster`.

## Limitations

For an already running cluster, these actions still require manual intervention:
- changing the :erlang_cookie
- turning :cluster from true to false


## License & Authors

- Author:: Benjamin Black (<b@b3k.us>)
- Author:: Daniel DeLeo (<dan@kallistec.com>)
- Author:: Matt Ray (<matt@chef.io>)
- Author:: Seth Thomas (<cheeseplus@chef.io>)
- Author:: JJ Asghar (<jj@chef.io>)

```text
Copyright (c) 2009-2015, Chef Software, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
