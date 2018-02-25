# RabbitMQ Chef Cookbook

[![Build Status](https://travis-ci.org/rabbitmq/chef-cookbook.svg?branch=master)](https://travis-ci.org/rabbitmq/chef-cookbook)
[![Cookbook Version](https://img.shields.io/cookbook/v/rabbitmq.svg)](https://supermarket.chef.io/cookbooks/rabbitmq)

This is a cookbook for managing RabbitMQ with Chef. 


## Supported Chef Versions

This cookbook targets Chef 12.1 and later.


## Dependencies

This cookbook depends on the [Erlang cookbook](https://supermarket.chef.io/cookbooks/erlang).


## Supported RabbitMQ Versions

`5.x` release series of this cookbook can provision any recent (3.7.x, 3.6.x) version and even older ones (e.g. 3.5.8),
provided that a [supported Erlang version](http://www.rabbitmq.com/which-erlang.html) is also provisioned.


### 3.7.x

#### Ensure Your Cookbook Version is Compatible

To provision RabbitMQ 3.7.x, you must use version `5.5.0` of this cookbook or later.
Older versions will use incorrect package download URLs.

#### Provision Erlang/OTP 19.3 or Later

Before provisioning a 3.7.x release, please beware that
the [minimum required Erlang version](http://www.rabbitmq.com/which-erlang.html) for it [is 19.3](https://github.com/rabbitmq/rabbitmq-server/releases/tag/v3.7.0).
Most distributions provide older versions, so Erlang must be provisioned either
from [Erlang Solutions](https://packages.erlang-solutions.com/erlang/) or [RabbitMQ's zero dependency Erlang RPM](https://github.com/rabbitmq/erlang-rpm).

The Erlang cookbook will provision packages from Erlang Solutions if `node['erlang']['install_method']` is set to `esl`:

``` ruby
# will install the latest release, please
# consult with https://www.rabbitmq.com/which-erlang.html first
node['erlang']['install_method'] = "esl"
```

to provision a specific version, e.g. 20.2.2:

``` ruby
node['erlang']['install_method'] = "esl"
# Ubuntu and Debian
# note the "1:" package epoch prefix
node['erlang']['esl']['version'] = "1:20.2.2"
```

``` ruby
node['erlang']['install_method'] = "esl"
# CentOS, RHEL, Fedora
node['erlang']['esl']['version'] = "20.2.2-1"
```

#### Set RabbitMQ Version

Set `node['rabbitmq']['version']` to specify a version:

``` ruby
node['rabbitmq']['version'] = "3.7.3"
```

If you have `node['rabbitmq']['deb_package_url']` or `node['rabbitmq']['deb_package_url']` overridden
from earlier versions, consider omitting those attributes. Otherwise see a section on download
location customization below.

3.7.x releases will be downloaded [from Bintray](https://bintray.com/rabbitmq/all/) by default.


### 3.6.x

Set `node['rabbitmq']['version']` to specify a version:

``` ruby
node['rabbitmq']['version'] = "3.6.15"
```

Erlang 19.3.6.5 or 20.x versions are [highly recommended](http://www.rabbitmq.com/which-erlang.html).

3.6.x releases will be downloaded [from GitHub](https://github.com/rabbitmq/rabbitmq-server/releases/) by default.



## Supported Distributions

The release was tested with recent RabbitMQ releases on

- CentOS 7.0
- Ubuntu 14.04
- Ubuntu 16.04
- Debian 8.0

Those are the distributions currently used to run tests [with Kitchen](.kitchen.cloud.yml).

Local Kitchen tests and user experience suggest that more recent Debian, Ubuntu and CentOS 7.x versions
should work just fine.

## Recipes

### default

Installs `rabbitmq-server` via direct download (from Bintray or GitHub, depending on the version) of
the installation package or using the distribution version. Depending on your distribution,
the provided version may be quite old so direct download is the default option.

If you want to use the distro version, set the attribute `['rabbitmq']['use_distro_version']` to `true`.

The cluster recipe is now combined with the default and will now auto-cluster. Set the `['rabbitmq']['clustering']['enable']` attribute to `true`, `['rabbitmq']['clustering']['cluster_disk_nodes']` array of `node@host` strings that describe which you want to be disk nodes and then set an alphanumeric string for the `erlang_cookie`.

To enable SSL turn `ssl` to `true` and set the paths to your cacert, cert and key files.

```ruby
node['rabbitmq']['ssl'] = true
node['rabbitmq']['ssl_cacert'] = '/path/to/cacert.pem'
node['rabbitmq']['ssl_cert'] = '/path/to/cert.pem'
node['rabbitmq']['ssl_key'] = '/path/to/key.pem'
```

Listening for TCP connections may be limited to a specific interface by setting the following attribute:

```
node['rabbitmq']['tcp_listen_interface'] = nil
```

Listening for SSL connections may be limited to a specific interface by setting the following attribute:

```
node['rabbitmq']['ssl_listen_interface'] = nil
```

#### Custom Package Download Locations

`node['rabbitmq']['deb_package_url']` and `node['rabbitmq']['deb_package_url']` can be used
to override the package download location. They configure a prefix without a version.
Set them to a download location without a version if you want to provision from a custom
endpoint such as a local mirror.

The `default` recipe will append a version suffix that matches RabbitMQ tag naming scheme.
For 3.7.x or later, it is just the version (unchanged). For 3.6.x and 3.5.x, it is
`"rabbitmq_v{version}"` where `{version}` being the value of `node['rabbitmq']['version']` with dots replaced by underscores.
So, `3.6.15` will be translated to `rabbitmq_v3_6_15`.

Lastly, a package name will be appended to form a full download URL. They rarely need
changing but can also be overridden using the `node['rabbitmq']['deb_package']`
and `node['rabbitmq']['rpm_package']` attributes.


#### Attributes

A full list of SSL attributes can be found in [attributes/default.rb](attributes/default.rb).

Default values and usage information of important attributes are shown below.  More attributes are documented in metadata.rb.

##### Username and Password

The default username and password are guest/guest:

`['rabbitmq']['default_user'] = 'guest'`

`['rabbitmq']['default_pass'] = 'guest'`

##### Loopback Users
By default, the guest user can only connect via localhost.  This is the behavior of RabbitMQ when the loopback_users configuration is not specified in it's configuration file.   Also, by default, this cookbook does not specify loopback_users in the configuration file:

`['rabbitmq']['loopback_users'] = nil`

If you wish to allow the default guest user to connect remotely, you can change this to `[]`. If instead you wanted to allow just the user 'foo' to connect over loopback, you would set this value to `["foo"]`. Learn more
in the RabbitMQ [Access Control guide](https://www.rabbitmq.com/access-control.html).

##### Definitions Import

[RabbitMQ management plugin](http://www.rabbitmq.com/management.html) provides a means to load a definitions
(schema) file on node boot. See [Definitions Export and Import](http://www.rabbitmq.com/management.html#load-definitions)
and [Backup](http://www.rabbitmq.com/backup.html) guides for details.

To configure definition loading, set the following attribute:

`['rabbitmq']['management']['load_definitions'] = true`

By default, the node will be configured to load a JSON at `/etc/rabbitmq/load_definitions.json`;
however, you can define another path if you'd prefer using the following attribute:

`['rabbitmq']['management']['definitions_file'] = '/path/to/your/definitions.json'`

In order to use this functionality, you will need to provision a file referenced by the above attribute
before you execute any recipes in the RabbitMQ cookbook (in other words, before the node starts). For example, this can be done
using a remote file resource.

### mgmt_console
Installs the `rabbitmq_management` plugin.
To use https connection to management console, turn `['rabbitmq']['web_console_ssl']` to true. The SSL port for web management console can be configured by setting attribute `['rabbitmq']['web_console_ssl_port']`, whose default value is 15671.

### plugin_management
Enables any plugins listed in the `node['rabbitmq']['enabled_plugins']` and disables any listed in `node['rabbitmq']['disabled_plugins']` attributes.

### community_plugins
Downloads, installs and enables pre-built community plugins binaries.

To specify a plugin, set the attribute `node['rabbitmq']['community_plugins']['PLUGIN_NAME']` to `'{DOWNLOAD_URL}'`.

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

Note that with this approach user credentials will be stored in the attribute file.
Using encrypted data bags is therefore highly recommended.

Alternatively [definitions export and import](http://www.rabbitmq.com/management.html#load-definitions) (see above) can be used.
Definition files contain password hashes since clear text values are not stored.

### virtualhost_management
Enables any vhosts listed in the `node['rabbitmq']['virtualhosts']` and disables any listed in `node['rabbitmq']['disabled_virtualhosts']` attributes.

### cluster

Configures a cluster of nodes.

It supports two clustering modes: auto or manual.

* Auto clustering: lists [cluster nodes in the RabbitMQ config file](http://www.rabbitmq.com/cluster-formation.html#peer-discovery-classic-config). Those are taken from lists the nodes `node['rabbitmq']['clustering']['cluster_nodes']`.
* Manual clustering : Configure the cluster by executing `rabbitmqctl join_cluster` command.

#### Attributes

* `node['rabbitmq']['clustering']['enable']` : Default decision flag of clustering
* `node['rabbitmq']['erlang_cookie']` : Same erlang cookie is required for the cluster
* `node['rabbitmq']['clustering']['use_auto_clustering']` : Default is false. (manual clustering is default)
* `node['rabbitmq']['clustering']['cluster_name']` : Name of cluster. default value is nil. In case of nil or '' is set for `cluster_name`, first node name in `node['rabbitmq']['clustering']['cluster_nodes']` attribute will be set for manual clustering. for the auto clustering, one of the node name will be set.
* `node['rabbitmq']['clustering']['cluster_nodes']` : List of cluster nodes. it required node name and cluster node type. please refer to example in below.

Example

```ruby
node['rabbitmq']['clustering']['enable'] = true
node['rabbitmq']['erlang_cookie'] = 'AnyAlphaNumericStringWillDo'
node['rabbitmq']['clustering']['cluster_partition_handling'] = 'pause_minority'
node['rabbitmq']['clustering']['use_auto_clustering'] = false
node['rabbitmq']['clustering']['cluster_name'] = 'qa_env'
node['rabbitmq']['clustering']['cluster_nodes'] = [
    {
        :name => 'rabbit@rabbit1'
    },
    {
        :name => 'rabbit@rabbit2'
    },
    {
        :name => 'rabbit@rabbit3'
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

- Author:: Benjamin Black
- Author:: Daniel DeLeo
- Author:: Matt Ray
- Author:: Seth Thomas
- Author:: JJ Asghar
- Author:: Team RabbitMQ

```text
Copyright (c) 2009-2018, Chef Software, Inc.

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
