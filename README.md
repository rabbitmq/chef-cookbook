Description
===========
This is a cookbook for managing RabbitMQ with Chef. It is intended for 2.6.1 or later releases.

Version 2.0 Changes
===================
The 2.0 release of the cookbook defaults to using the latest version available from RabbitMQ.com via direct download of the package. This was done to simplify the installation options to either distro package or direct download. The attributes `use_apt` and `use_yum` have been removed as have the `apt` and `yum` cookbook dependencies. The user LWRP action `:set_user_tags` was changed to `:set_tags` for consistency with other actions.

This release was tested with:
* CentOS 5.8: 3.0.4 (distro release unsupported)
* CentOS 6.3: 3.0.4/2.6.1 (no plugin support)
* Debian 6: 3.04 (distro release unsupported)
* Ubuntu 10.04: 3.0.4 (distro release unsupported)
* Ubuntu 12.04: 3.0.4/2.7.1

Recipes
=======
default
-------
Installs `rabbitmq-server` from RabbitMQ.com via direct download of the installation package or using the distribution version. Depending on your distribution, the provided version may be quite old so they are disabled by default. If you want to use the distro version, set the attribute `['rabbitmq']['use_distro_version']` to `true`. You may override the download URL attribute `['rabbitmq']['package']` if you wish to use a local mirror.

The cluster recipe is now combined with the default and will now auto-cluster. Set the `['rabbitmq']['cluster']` attribute to `true`, `['rabbitmq']['cluster_disk_nodes']` array of `node@host` strings that describe which you want to be disk nodes and then set an alphanumeric string for the `erlang_cookie`.

To enable SSL turn `ssl` to `true` and set the paths to your cacert, cert and key files.

Resources/Providers
===================
There are 3 LWRPs for interacting with RabbitMQ.

user
----
Adds and deletes users, fairly simplistic permissions management.

- `:add` adds a `user` with a `password`
- `:delete` deletes a `user`
- `:set_permissions` sets the `permissions` for a `user`, `vhost` is optional
- `:clear_permissions` clears the permissions for a `user`
- `:set_tags` set the tags on a user
- `:clear_tags` clear any tags on a user

### Examples
``` ruby
rabbitmq_user "guest" do
  action :delete
end

rabbitmq_user "nova" do
  password "sekret"
  action :add
end

rabbitmq_user "nova" do
  vhost "/nova"
  permissions ".* .* .*"
  action :set_permissions
end

rabbitmq_user "joe" do
  tag "admin,lead"
  action :set_tags
end
```

vhost
-----
Adds and deletes vhosts.

- `:add` adds a `vhost`
- `:delete` deletes a `vhost`

### Example
``` ruby
rabbitmq_vhost "/nova" do
  action :add
end
```

plugin
-----
Enables or disables a rabbitmq plugin. Plugins are not supported for releases prior to 2.7.0.

- `:enable` enables a `plugin`
- `:disable` disables a `plugin`

### Example
``` ruby
rabbitmq_plugin "rabbitmq_stomp" do
  action :enable
end

rabbitmq_plugin "rabbitmq_shovel" do
  action :disable
end
```

policy
-----
sets or clears a rabbitmq policy.

- `:set` sets a `policy`
- `:clear` clears a `policy`
- `:list` lists `policy`s

### Example
``` ruby
rabbitmq_policy "ha-all" do
  pattern "^(?!amq\\.).*"
  params {"ha-mode"=>"all"}
  priority 1
  action :set
end

rabbitmq_policy "ha-all" do
  action :clear
end
```

Limitations
===========
For an already running cluster, these actions still require manual intervention:
- changing the :erlang_cookie
- turning :cluster from true to false

The `rabbitmq::chef` recipe was only used for the chef-server cookbook and has been moved to `chef-server::rabbitmq`.

License and Author
==================

Author:: Benjamin Black <b@b3k.us>
Author:: Daniel DeLeo <dan@kallistec.com>
Author:: Matt Ray <matt@opscode.com>

Copyright:: 2009-2013 Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
