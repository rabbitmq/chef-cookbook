# Change Log

## [4.9.0](https://github.com/rabbitmq/chef-cookbook/tree/v4.9.0) (2016-08-02)

[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/v4.8.0...v4.9.0)

**Closed issues:**

- what i should do about rabbitmq lay4 check？ [\#386](https://github.com/rabbitmq/chef-cookbook/issues/386)
- Mixlib::ShellOut environment setter does not exist. [\#375](https://github.com/rabbitmq/chef-cookbook/issues/375)
- No candidate version available for rabbitmq-server in Ubuntu 14.04 and 4.7.0 [\#356](https://github.com/rabbitmq/chef-cookbook/issues/356)

**Merged pull requests:**

- Comments out example HA policy attributes [\#384](https://github.com/rabbitmq/chef-cookbook/pull/384) ([dgoradia](https://github.com/dgoradia))
- Fix warning:already initialized constant LOG\_LEVEL [\#378](https://github.com/rabbitmq/chef-cookbook/pull/378) ([ruizink](https://github.com/ruizink))
- Update bundler that comes with Travis' ruby 2.1.0. [\#377](https://github.com/rabbitmq/chef-cookbook/pull/377) ([ruizink](https://github.com/ruizink))
- Fixes \#375. Assign environment via constructor. [\#376](https://github.com/rabbitmq/chef-cookbook/pull/376) ([ruizink](https://github.com/ruizink))

## [v4.8.0](https://github.com/rabbitmq/chef-cookbook/tree/v4.8.0) (2016-06-02)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/v4.7.0...v4.8.0)

**Closed issues:**

- undefined method `node\_type' for Custom resource rabbitmq\_cluster from cookbook rabbitmq [\#366](https://github.com/rabbitmq/chef-cookbook/issues/366)
- esl-erlang-compat is not needed for 'esl install method' [\#360](https://github.com/rabbitmq/chef-cookbook/issues/360)
- RabbitMQ 3.6.2 will have a dependency on socat [\#355](https://github.com/rabbitmq/chef-cookbook/issues/355)
- Cluster LWRP :join action leaves Rabbit stopped on join error [\#344](https://github.com/rabbitmq/chef-cookbook/issues/344)
- Wrong method in set\_cluster\_name matcher [\#342](https://github.com/rabbitmq/chef-cookbook/issues/342)
- Duplicate attributes \['cluster\_disk\_nodes'\] vs \['clustering'\]\['cluster\_nodes'\] [\#268](https://github.com/rabbitmq/chef-cookbook/issues/268)

**Merged pull requests:**

- v4.8.0 [\#374](https://github.com/rabbitmq/chef-cookbook/pull/374) ([jjasghar](https://github.com/jjasghar))
- Updated to cookstyle [\#373](https://github.com/rabbitmq/chef-cookbook/pull/373) ([jjasghar](https://github.com/jjasghar))
- Added socat [\#372](https://github.com/rabbitmq/chef-cookbook/pull/372) ([jjasghar](https://github.com/jjasghar))
- Fix set\_cluster\_name ChefSpec matcher [\#371](https://github.com/rabbitmq/chef-cookbook/pull/371) ([josacar](https://github.com/josacar))
- Update cipher examples [\#370](https://github.com/rabbitmq/chef-cookbook/pull/370) ([yoshiwaan](https://github.com/yoshiwaan))
- fix cluster\_nodes config line syntax when using auto clustering [\#368](https://github.com/rabbitmq/chef-cookbook/pull/368) ([devsibwarra](https://github.com/devsibwarra))
- Fix typo in name of rabbitmq clustering enable attribute [\#367](https://github.com/rabbitmq/chef-cookbook/pull/367) ([jperville](https://github.com/jperville))
- Restart Rabbit on cluster join error, resolves \#344 [\#346](https://github.com/rabbitmq/chef-cookbook/pull/346) ([CVTJNII](https://github.com/CVTJNII))

## [v4.7.0](https://github.com/rabbitmq/chef-cookbook/tree/v4.7.0) (2016-03-25)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/v4.6.0...v4.7.0)

**Closed issues:**

- Nodes try to rejoin cluster when first listed node is down [\#347](https://github.com/rabbitmq/chef-cookbook/issues/347)
- Logrotating [\#338](https://github.com/rabbitmq/chef-cookbook/issues/338)
- rabbitmq\_plugin\[rabbitmq\_management\] erlexec: HOME must be set [\#334](https://github.com/rabbitmq/chef-cookbook/issues/334)
- Is "notifies restart" necessary for enabling or disabling a policy? [\#319](https://github.com/rabbitmq/chef-cookbook/issues/319)
- Alternate restarts fail on CentOS [\#264](https://github.com/rabbitmq/chef-cookbook/issues/264)
- rabbitmq-server fail to start after setting the cipher suites [\#259](https://github.com/rabbitmq/chef-cookbook/issues/259)
- Add auth\_backends attribute [\#230](https://github.com/rabbitmq/chef-cookbook/issues/230)

**Merged pull requests:**

- 4.7.0 prep [\#354](https://github.com/rabbitmq/chef-cookbook/pull/354) ([jjasghar](https://github.com/jjasghar))
- Pass a HOME environment variable to all rabbitmq execute blocks [\#352](https://github.com/rabbitmq/chef-cookbook/pull/352) ([RoboticCheese](https://github.com/RoboticCheese))
- added an example to the "user\_management" section. [\#350](https://github.com/rabbitmq/chef-cookbook/pull/350) ([farshidce](https://github.com/farshidce))
- Fix check for whether node has joined cluster [\#348](https://github.com/rabbitmq/chef-cookbook/pull/348) ([ccrebolder](https://github.com/ccrebolder))
- Update metadata.rb with config\_template\_cookbook [\#345](https://github.com/rabbitmq/chef-cookbook/pull/345) ([jgonera](https://github.com/jgonera))
- simplified clustering logic [\#340](https://github.com/rabbitmq/chef-cookbook/pull/340) ([jklare](https://github.com/jklare))
- Package install logrotate for \*.log [\#339](https://github.com/rabbitmq/chef-cookbook/pull/339) ([ptqa](https://github.com/ptqa))
- Debian Fixes [\#330](https://github.com/rabbitmq/chef-cookbook/pull/330) ([bdwyertech](https://github.com/bdwyertech))
- Use init if job\_control uses init. [\#303](https://github.com/rabbitmq/chef-cookbook/pull/303) ([rogerhu](https://github.com/rogerhu))

## [v4.6.0](https://github.com/rabbitmq/chef-cookbook/tree/v4.6.0) (2016-02-02)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/v4.5.1...v4.6.0)

**Closed issues:**

- Problems getting erlang 1.5.x version on Ubuntu 14.04 [\#336](https://github.com/rabbitmq/chef-cookbook/issues/336)
- node type is being ignored when joining a cluster [\#326](https://github.com/rabbitmq/chef-cookbook/issues/326)
- Chef restarts RabbitMQ because it always set the permissions to all the users when it runs [\#197](https://github.com/rabbitmq/chef-cookbook/issues/197)

**Merged pull requests:**

- v4.6.0 prep work [\#337](https://github.com/rabbitmq/chef-cookbook/pull/337) ([jjasghar](https://github.com/jjasghar))
- Fix user grep command to match whitespace [\#331](https://github.com/rabbitmq/chef-cookbook/pull/331) ([gerr1t](https://github.com/gerr1t))
- fix hardcoded --ram node type for cluster join [\#327](https://github.com/rabbitmq/chef-cookbook/pull/327) ([scalp42](https://github.com/scalp42))
- NO-REF Check chef client version before calling sensitive [\#317](https://github.com/rabbitmq/chef-cookbook/pull/317) ([XiangYao](https://github.com/XiangYao))

## [v4.5.1](https://github.com/rabbitmq/chef-cookbook/tree/v4.5.1) (2015-11-24)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/v4.5.0...v4.5.1)

**Merged pull requests:**

- Fix the missing comma in rabbitmq config [\#324](https://github.com/rabbitmq/chef-cookbook/pull/324) ([mgosalia](https://github.com/mgosalia))

## [v4.5.0](https://github.com/rabbitmq/chef-cookbook/tree/v4.5.0) (2015-11-24)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/v4.4.0...v4.5.0)

**Closed issues:**

- Upgrade to "-3\_all.deb" [\#311](https://github.com/rabbitmq/chef-cookbook/issues/311)
- Changelog missing entries for 4.2.1 and 4.2.2 [\#306](https://github.com/rabbitmq/chef-cookbook/issues/306)
- Logrotate Error on Ubuntu 14.04 [\#283](https://github.com/rabbitmq/chef-cookbook/issues/283)
- 'node\_name' method bug in cluster.rb recipe [\#271](https://github.com/rabbitmq/chef-cookbook/issues/271)
- RabbitMQ 3.5.2  [\#266](https://github.com/rabbitmq/chef-cookbook/issues/266)
- Error for clustering cluster\_nodes use with cluster.rb [\#265](https://github.com/rabbitmq/chef-cookbook/issues/265)
- Recreate kitchen tests for Clustering [\#258](https://github.com/rabbitmq/chef-cookbook/issues/258)
- CHEF-3694 warnings [\#221](https://github.com/rabbitmq/chef-cookbook/issues/221)
- Not able to clear a policy which was created in a vhost [\#204](https://github.com/rabbitmq/chef-cookbook/issues/204)
- RabbitMQ Auto-Clustering [\#156](https://github.com/rabbitmq/chef-cookbook/issues/156)
- Add missing attribute `rabbitmq.hipe\_compile` [\#146](https://github.com/rabbitmq/chef-cookbook/issues/146)
- nodes not joining cluster  [\#125](https://github.com/rabbitmq/chef-cookbook/issues/125)

**Merged pull requests:**

- 4.5.0 [\#323](https://github.com/rabbitmq/chef-cookbook/pull/323) ([jjasghar](https://github.com/jjasghar))
- Enable chef setting for tcp\_listen linger option [\#321](https://github.com/rabbitmq/chef-cookbook/pull/321) ([mgosalia](https://github.com/mgosalia))
- Readme improvements [\#318](https://github.com/rabbitmq/chef-cookbook/pull/318) ([Fitzsimmons](https://github.com/Fitzsimmons))
- Allow the partition handling to be set even if we are not using auto clustering [\#307](https://github.com/rabbitmq/chef-cookbook/pull/307) ([joshgarnett](https://github.com/joshgarnett))

## [v4.4.0](https://github.com/rabbitmq/chef-cookbook/tree/v4.4.0) (2015-10-12)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/v4.3.2...v4.4.0)

**Merged pull requests:**

- Provision 3.5.6 by default [\#315](https://github.com/rabbitmq/chef-cookbook/pull/315) ([michaelklishin](https://github.com/michaelklishin))

## [v4.3.2](https://github.com/rabbitmq/chef-cookbook/tree/v4.3.2) (2015-10-08)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/v4.3.1...v4.3.2)

**Merged pull requests:**

- Revert "Upgrade to -3\_all.deb" [\#312](https://github.com/rabbitmq/chef-cookbook/pull/312) ([jjasghar](https://github.com/jjasghar))

## [v4.3.1](https://github.com/rabbitmq/chef-cookbook/tree/v4.3.1) (2015-10-08)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/v4.3.0...v4.3.1)

**Merged pull requests:**

- Upgrade to -3\_all.deb [\#310](https://github.com/rabbitmq/chef-cookbook/pull/310) ([jdrago999](https://github.com/jdrago999))

## [v4.3.0](https://github.com/rabbitmq/chef-cookbook/tree/v4.3.0) (2015-10-08)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/v4.2.2...v4.3.0)

**Merged pull requests:**

- updated for 3.5.5 of rabbitmq [\#308](https://github.com/rabbitmq/chef-cookbook/pull/308) ([jjasghar](https://github.com/jjasghar))
- enable to configure log\_levels [\#291](https://github.com/rabbitmq/chef-cookbook/pull/291) ([nipe0324](https://github.com/nipe0324))

## [v4.2.2](https://github.com/rabbitmq/chef-cookbook/tree/v4.2.2) (2015-09-08)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/v4.2.1...v4.2.2)

**Merged pull requests:**

- logic around the apt-force-yes. [\#302](https://github.com/rabbitmq/chef-cookbook/pull/302) ([jjasghar](https://github.com/jjasghar))

## [v4.2.1](https://github.com/rabbitmq/chef-cookbook/tree/v4.2.1) (2015-09-08)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/v4.2.0...v4.2.1)

**Merged pull requests:**

- Fix for Issue 301 [\#301](https://github.com/rabbitmq/chef-cookbook/pull/301) ([jjasghar](https://github.com/jjasghar))

## [v4.2.0](https://github.com/rabbitmq/chef-cookbook/tree/v4.2.0) (2015-08-28)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/v4.1.2...v4.2.0)

**Closed issues:**

- Server failing unable to restart, able to restart when resetting queues [\#289](https://github.com/rabbitmq/chef-cookbook/issues/289)
- ulimit won't work if the current user doesnot have the limit higher or equal to 'rabbitmq' user [\#250](https://github.com/rabbitmq/chef-cookbook/issues/250)

**Merged pull requests:**

- Updates for 4.2.0 [\#298](https://github.com/rabbitmq/chef-cookbook/pull/298) ([jjasghar](https://github.com/jjasghar))
- rabbitmq.community\_plugins default should be {} [\#297](https://github.com/rabbitmq/chef-cookbook/pull/297) ([michaelklishin](https://github.com/michaelklishin))
- Fix regex in user.rb [\#296](https://github.com/rabbitmq/chef-cookbook/pull/296) ([jdrago999](https://github.com/jdrago999))
- Delay start of RabbitMQ on template changes [\#295](https://github.com/rabbitmq/chef-cookbook/pull/295) ([jschneiderhan](https://github.com/jschneiderhan))
- esl-erlang-compat now provides Erlang R16B03-1 [\#294](https://github.com/rabbitmq/chef-cookbook/pull/294) ([michaelklishin](https://github.com/michaelklishin))
- Provision 3.5.4 by default [\#293](https://github.com/rabbitmq/chef-cookbook/pull/293) ([michaelklishin](https://github.com/michaelklishin))
- removing ulimit from rabbitmq-env.conf [\#292](https://github.com/rabbitmq/chef-cookbook/pull/292) ([jordant](https://github.com/jordant))
- Fixed rabbitmq cluster\_status parsing when node list takes multiple lines. [\#290](https://github.com/rabbitmq/chef-cookbook/pull/290) ([jperville](https://github.com/jperville))

## [v4.1.2](https://github.com/rabbitmq/chef-cookbook/tree/v4.1.2) (2015-07-17)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/v4.1.1...v4.1.2)

**Closed issues:**

- cluster resource : possible bug in running\_nodes method [\#285](https://github.com/rabbitmq/chef-cookbook/issues/285)
- cluster resource : possible bug in node\_name method [\#282](https://github.com/rabbitmq/chef-cookbook/issues/282)

## [v4.1.1](https://github.com/rabbitmq/chef-cookbook/tree/v4.1.1) (2015-07-17)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/v4.0.1...v4.1.1)

**Closed issues:**

- Feature Request: Support rabbitmq\_user with multiple vhosts. [\#278](https://github.com/rabbitmq/chef-cookbook/issues/278)

**Merged pull requests:**

- Fix exception when first node is launched. Fixes issue \#285 [\#286](https://github.com/rabbitmq/chef-cookbook/pull/286) ([alexpop](https://github.com/alexpop))
- Use gsub instead of gsub! [\#284](https://github.com/rabbitmq/chef-cookbook/pull/284) ([stevedomin](https://github.com/stevedomin))
- Allow the service to be manually managed [\#281](https://github.com/rabbitmq/chef-cookbook/pull/281) ([joshgarnett](https://github.com/joshgarnett))
- Allow for flexiable SSL cipher formats [\#280](https://github.com/rabbitmq/chef-cookbook/pull/280) ([kramvan1](https://github.com/kramvan1))
- Support rabbitmq\_user with multiple vhosts. [\#279](https://github.com/rabbitmq/chef-cookbook/pull/279) ([jemc](https://github.com/jemc))
- Changes from let to cached [\#277](https://github.com/rabbitmq/chef-cookbook/pull/277) ([jjasghar](https://github.com/jjasghar))

## [v4.0.1](https://github.com/rabbitmq/chef-cookbook/tree/v4.0.1) (2015-06-16)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/v4.0.0...v4.0.1)

**Closed issues:**

- wrapper cookbook - node\['rabbitmq'\]\['deb\_package\_url\] has not been overrided during  execution phase [\#270](https://github.com/rabbitmq/chef-cookbook/issues/270)

**Merged pull requests:**

- Changes for 4.0.1 to be pushed. [\#275](https://github.com/rabbitmq/chef-cookbook/pull/275) ([jjasghar](https://github.com/jjasghar))
- Fix single quote and nil issues with cluster recipe [\#274](https://github.com/rabbitmq/chef-cookbook/pull/274) ([dude051](https://github.com/dude051))
- Fixed 'rabbitmqctl eval' command for old rabbitmq versions [\#272](https://github.com/rabbitmq/chef-cookbook/pull/272) ([XiangYao](https://github.com/XiangYao))
- Support additional env args [\#269](https://github.com/rabbitmq/chef-cookbook/pull/269) ([krtyyy](https://github.com/krtyyy))
- Add patterns to catch where the node name is surrounded by single-quotes [\#267](https://github.com/rabbitmq/chef-cookbook/pull/267) ([monkey1016](https://github.com/monkey1016))
- Remove the extra curly braces for format\_ssl\_ciphers [\#260](https://github.com/rabbitmq/chef-cookbook/pull/260) ([wenchma](https://github.com/wenchma))

## [v4.0.0](https://github.com/rabbitmq/chef-cookbook/tree/v4.0.0) (2015-04-24)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/v3.13.0...v4.0.0)

**Closed issues:**

- Unable to set/override default\_user/pass [\#245](https://github.com/rabbitmq/chef-cookbook/issues/245)

**Merged pull requests:**

- 4.0.0 release [\#257](https://github.com/rabbitmq/chef-cookbook/pull/257) ([jjasghar](https://github.com/jjasghar))
- allowing to clear a policy which is created in a vhost [\#203](https://github.com/rabbitmq/chef-cookbook/pull/203) ([cvasii](https://github.com/cvasii))

## [v3.13.0](https://github.com/rabbitmq/chef-cookbook/tree/v3.13.0) (2015-04-23)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/v3.12.0...v3.13.0)

**Merged pull requests:**

- 3.13.0 [\#256](https://github.com/rabbitmq/chef-cookbook/pull/256) ([jjasghar](https://github.com/jjasghar))
- Added ssl\_ciphers [\#255](https://github.com/rabbitmq/chef-cookbook/pull/255) ([kramvan1](https://github.com/kramvan1))
- Fix plugin\_enabled not having path appended [\#253](https://github.com/rabbitmq/chef-cookbook/pull/253) ([Itxaka](https://github.com/Itxaka))
- Fix \#245 [\#252](https://github.com/rabbitmq/chef-cookbook/pull/252) ([cheeseplus](https://github.com/cheeseplus))
- Add more support for erlang args [\#247](https://github.com/rabbitmq/chef-cookbook/pull/247) ([kramvan1](https://github.com/kramvan1))

## [v3.12.0](https://github.com/rabbitmq/chef-cookbook/tree/v3.12.0) (2015-04-07)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/v3.11.0...v3.12.0)

**Closed issues:**

- seems cookbook is unable to set/override default username & password \#245 [\#246](https://github.com/rabbitmq/chef-cookbook/issues/246)
- Oops [\#242](https://github.com/rabbitmq/chef-cookbook/issues/242)
- metadata.rb is missing in rabbitmq 3.10.0 cookbook [\#233](https://github.com/rabbitmq/chef-cookbook/issues/233)
- Installation fails if you decide to install erlang from sources [\#224](https://github.com/rabbitmq/chef-cookbook/issues/224)
- 3.4.4 has been released.  [\#222](https://github.com/rabbitmq/chef-cookbook/issues/222)
- Use default version not working in CentOS [\#218](https://github.com/rabbitmq/chef-cookbook/issues/218)
- No changelog for 3.10 [\#216](https://github.com/rabbitmq/chef-cookbook/issues/216)
- When updating the user attributes or the policy attributes they are not taken into consideration if the resource already exists [\#205](https://github.com/rabbitmq/chef-cookbook/issues/205)
- rabbitmq-server can't be started when selinux is enforcing on redhat 7 [\#200](https://github.com/rabbitmq/chef-cookbook/issues/200)
- erlang broken [\#199](https://github.com/rabbitmq/chef-cookbook/issues/199)
- Replace the hard links for package sources with attributes [\#192](https://github.com/rabbitmq/chef-cookbook/issues/192)
- Centos 7.0 support [\#189](https://github.com/rabbitmq/chef-cookbook/issues/189)
- cannot\_read\_enabled\_plugins\_file - eacces [\#182](https://github.com/rabbitmq/chef-cookbook/issues/182)
- loopback\_users cannot be configured [\#159](https://github.com/rabbitmq/chef-cookbook/issues/159)
- .erlang.cookie is ignored [\#137](https://github.com/rabbitmq/chef-cookbook/issues/137)
- Configuring default\_user and default\_pass in rabbitmq.config  is insecure [\#136](https://github.com/rabbitmq/chef-cookbook/issues/136)
- policy provider does not support apply-to [\#135](https://github.com/rabbitmq/chef-cookbook/issues/135)
- Kernel parameters errors [\#124](https://github.com/rabbitmq/chef-cookbook/issues/124)

**Merged pull requests:**

- 3.12.0 [\#249](https://github.com/rabbitmq/chef-cookbook/pull/249) ([jjasghar](https://github.com/jjasghar))
- Fix command error in provider/user.rb [\#243](https://github.com/rabbitmq/chef-cookbook/pull/243) ([shalq](https://github.com/shalq))
- \[\#125\] - Enhancing clustering functionality [\#238](https://github.com/rabbitmq/chef-cookbook/pull/238) ([sunggun-yu](https://github.com/sunggun-yu))
- don't put change password in log [\#237](https://github.com/rabbitmq/chef-cookbook/pull/237) ([kramvan1](https://github.com/kramvan1))
- Remove yum-epel case statement. [\#236](https://github.com/rabbitmq/chef-cookbook/pull/236) ([cmluciano](https://github.com/cmluciano))
- Added pin\_distro\_version for other platforms [\#234](https://github.com/rabbitmq/chef-cookbook/pull/234) ([kramvan1](https://github.com/kramvan1))
- addition of attributes for downloading deb, rpm and esl-erlang-compat [\#220](https://github.com/rabbitmq/chef-cookbook/pull/220) ([dannietjoh](https://github.com/dannietjoh))
- umask [\#219](https://github.com/rabbitmq/chef-cookbook/pull/219) ([cmluciano](https://github.com/cmluciano))
- Additional rabbit configs [\#217](https://github.com/rabbitmq/chef-cookbook/pull/217) ([jacyzon](https://github.com/jacyzon))
- Allow specifying allowed ssl protocol versions via attributes [\#152](https://github.com/rabbitmq/chef-cookbook/pull/152) ([JonathanTron](https://github.com/JonathanTron))
- Open file limit not set correctly [\#127](https://github.com/rabbitmq/chef-cookbook/pull/127) ([jessedavis](https://github.com/jessedavis))

## [v3.11.0](https://github.com/rabbitmq/chef-cookbook/tree/v3.11.0) (2015-02-26)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/v3.10.0...v3.11.0)

**Closed issues:**

- Recipe stops server to change erlang cookie even when it's not necessary [\#232](https://github.com/rabbitmq/chef-cookbook/issues/232)
- Type Error with newest code [\#227](https://github.com/rabbitmq/chef-cookbook/issues/227)
- Add support for multiple nodes on one machine [\#225](https://github.com/rabbitmq/chef-cookbook/issues/225)

**Merged pull requests:**

- Change module back to Opscode. [\#231](https://github.com/rabbitmq/chef-cookbook/pull/231) ([cmluciano](https://github.com/cmluciano))
- Update Contributing file with new links and help. [\#229](https://github.com/rabbitmq/chef-cookbook/pull/229) ([cmluciano](https://github.com/cmluciano))
- Fix travis build. [\#228](https://github.com/rabbitmq/chef-cookbook/pull/228) ([cmluciano](https://github.com/cmluciano))
- 3.4.4 was released and this is the update [\#223](https://github.com/rabbitmq/chef-cookbook/pull/223) ([jjasghar](https://github.com/jjasghar))

## [v3.10.0](https://github.com/rabbitmq/chef-cookbook/tree/v3.10.0) (2015-02-05)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/v3.9.0...v3.10.0)

**Closed issues:**

- version pining does not work by default with use\_distro\_version [\#210](https://github.com/rabbitmq/chef-cookbook/issues/210)

**Merged pull requests:**

- changed regex behavior for guard command on set user permission resource  [\#215](https://github.com/rabbitmq/chef-cookbook/pull/215) ([fnicholas](https://github.com/fnicholas))
- CentOS 7 support [\#214](https://github.com/rabbitmq/chef-cookbook/pull/214) ([jjasghar](https://github.com/jjasghar))
- inital enforcement of Gemfile.lock [\#213](https://github.com/rabbitmq/chef-cookbook/pull/213) ([jjasghar](https://github.com/jjasghar))
- \*  add support for looback users [\#212](https://github.com/rabbitmq/chef-cookbook/pull/212) ([sethcall](https://github.com/sethcall))
- Add more chefspec tests [\#193](https://github.com/rabbitmq/chef-cookbook/pull/193) ([wenchma](https://github.com/wenchma))

## [v3.9.0](https://github.com/rabbitmq/chef-cookbook/tree/v3.9.0) (2015-01-28)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/v3.8.0...v3.9.0)

**Closed issues:**

- Can't successfully rerun the cookbook if set the wrong parameter the first time [\#201](https://github.com/rabbitmq/chef-cookbook/issues/201)
- New version 3.4.3 released [\#195](https://github.com/rabbitmq/chef-cookbook/issues/195)
- More chefspec test coverage [\#190](https://github.com/rabbitmq/chef-cookbook/issues/190)

**Merged pull requests:**

- Distro version pinning [\#211](https://github.com/rabbitmq/chef-cookbook/pull/211) ([kramvan1](https://github.com/kramvan1))
- syntax typos [\#208](https://github.com/rabbitmq/chef-cookbook/pull/208) ([stensonb](https://github.com/stensonb))
- LWRP for managing RabbitMQ parameters [\#207](https://github.com/rabbitmq/chef-cookbook/pull/207) ([portertech](https://github.com/portertech))
- Fix for Issue \#201 [\#202](https://github.com/rabbitmq/chef-cookbook/pull/202) ([jjasghar](https://github.com/jjasghar))

## [v3.8.0](https://github.com/rabbitmq/chef-cookbook/tree/v3.8.0) (2015-01-08)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/v3.7.0...v3.8.0)

**Closed issues:**

- Wrong service provider used on Linux Mint [\#194](https://github.com/rabbitmq/chef-cookbook/issues/194)
- undefined method `sensitive' for Chef::Resource::Execute [\#191](https://github.com/rabbitmq/chef-cookbook/issues/191)
- Chef \>= 11.14.0 requirement [\#183](https://github.com/rabbitmq/chef-cookbook/issues/183)
- Change the rabbitmq config file path via cookbook will not take effect [\#157](https://github.com/rabbitmq/chef-cookbook/issues/157)

**Merged pull requests:**

- 3.4.3 release [\#196](https://github.com/rabbitmq/chef-cookbook/pull/196) ([jjasghar](https://github.com/jjasghar))

## [v3.7.0](https://github.com/rabbitmq/chef-cookbook/tree/v3.7.0) (2014-12-18)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/v3.6.0...v3.7.0)

**Closed issues:**

- RabbitMQ should get pinned on Debian based systems [\#178](https://github.com/rabbitmq/chef-cookbook/issues/178)

**Merged pull requests:**

- Updating Readme [\#187](https://github.com/rabbitmq/chef-cookbook/pull/187) ([jjasghar](https://github.com/jjasghar))
- Added Three different os supports [\#186](https://github.com/rabbitmq/chef-cookbook/pull/186) ([jjasghar](https://github.com/jjasghar))
- Updating kitchen configs and fixing tests [\#185](https://github.com/rabbitmq/chef-cookbook/pull/185) ([cheeseplus](https://github.com/cheeseplus))
- Supports setting rabbitmq config file to a different path [\#184](https://github.com/rabbitmq/chef-cookbook/pull/184) ([wenchma](https://github.com/wenchma))
- Better upgrade and distro package installation. [\#180](https://github.com/rabbitmq/chef-cookbook/pull/180) ([jjasghar](https://github.com/jjasghar))

## [v3.6.0](https://github.com/rabbitmq/chef-cookbook/tree/v3.6.0) (2014-12-09)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/v3.5.1...v3.6.0)

**Fixed bugs:**

- Foodcritic failures [\#163](https://github.com/rabbitmq/chef-cookbook/issues/163)

**Closed issues:**

- Restarts after vhost creation [\#179](https://github.com/rabbitmq/chef-cookbook/issues/179)
- undefined method `path' for Chef::Resource::Execute [\#175](https://github.com/rabbitmq/chef-cookbook/issues/175)
- enabled\_plugins file permissions issue [\#174](https://github.com/rabbitmq/chef-cookbook/issues/174)
- rabbitmq doesn't support package upgrade [\#143](https://github.com/rabbitmq/chef-cookbook/issues/143)
- chef run fails when using upstart [\#134](https://github.com/rabbitmq/chef-cookbook/issues/134)

**Merged pull requests:**

- Community plugins [\#161](https://github.com/rabbitmq/chef-cookbook/pull/161) ([dggc](https://github.com/dggc))
- Adds policy apply\_to option [\#158](https://github.com/rabbitmq/chef-cookbook/pull/158) ([hufman](https://github.com/hufman))
- make config file template source cookbook configurable [\#151](https://github.com/rabbitmq/chef-cookbook/pull/151) ([mgreensmith](https://github.com/mgreensmith))
- COOK-4694 Remove service restart for vhost mgmnt [\#121](https://github.com/rabbitmq/chef-cookbook/pull/121) ([kamaradclimber](https://github.com/kamaradclimber))

## [v3.5.1](https://github.com/rabbitmq/chef-cookbook/tree/v3.5.1) (2014-12-05)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/v3.5.0...v3.5.1)

**Closed issues:**

- New Rabbitmq release [\#165](https://github.com/rabbitmq/chef-cookbook/issues/165)

**Merged pull requests:**

- Removing the PATH from the execute resource [\#176](https://github.com/rabbitmq/chef-cookbook/pull/176) ([jjasghar](https://github.com/jjasghar))

## [v3.5.0](https://github.com/rabbitmq/chef-cookbook/tree/v3.5.0) (2014-12-02)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/pull...v3.5.0)

**Fixed bugs:**

- Default for heartbeat is set higher then suggested [\#169](https://github.com/rabbitmq/chef-cookbook/issues/169)

**Closed issues:**

- Working with queues [\#173](https://github.com/rabbitmq/chef-cookbook/issues/173)
- Readme doesn't have 3.4.0 release [\#164](https://github.com/rabbitmq/chef-cookbook/issues/164)
- \['rabbitmq'\]\['config'\] should not be hard coding again [\#155](https://github.com/rabbitmq/chef-cookbook/issues/155)
- Failed to connect to rabbitmq many times during openstack deployemnt [\#153](https://github.com/rabbitmq/chef-cookbook/issues/153)
- Breaks in Chef 10 [\#149](https://github.com/rabbitmq/chef-cookbook/issues/149)
- Add sensitive flag for resources that expose passwords in log [\#147](https://github.com/rabbitmq/chef-cookbook/issues/147)
- Documentation Fix - Rabbitmq\_policy resource definition incorrect [\#133](https://github.com/rabbitmq/chef-cookbook/issues/133)

**Merged pull requests:**

- Updates \['rabbitmq'\]\['config'\] to use \['rabbitmq'\]\['config\_root'\] attribute [\#172](https://github.com/rabbitmq/chef-cookbook/pull/172) ([wenchma](https://github.com/wenchma))
- Changed the default heartbeat [\#170](https://github.com/rabbitmq/chef-cookbook/pull/170) ([jjasghar](https://github.com/jjasghar))
- Chefspec update [\#168](https://github.com/rabbitmq/chef-cookbook/pull/168) ([jjasghar](https://github.com/jjasghar))
- Updated to 3.4.2 release [\#166](https://github.com/rabbitmq/chef-cookbook/pull/166) ([jjasghar](https://github.com/jjasghar))
- Add raw configuration for rabbitmq.erb [\#123](https://github.com/rabbitmq/chef-cookbook/pull/123) ([kYann](https://github.com/kYann))
-  expose the heartbeat configuration parameter [\#87](https://github.com/rabbitmq/chef-cookbook/pull/87) ([kisoku](https://github.com/kisoku))

## [pull](https://github.com/rabbitmq/chef-cookbook/tree/pull) (2014-11-23)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/v3.4.0...pull)

## [v3.4.0](https://github.com/rabbitmq/chef-cookbook/tree/v3.4.0) (2014-11-23)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/v3.3.0...v3.4.0)

**Closed issues:**

- Intermittent notifies issue with plugin provider [\#141](https://github.com/rabbitmq/chef-cookbook/issues/141)

**Merged pull requests:**

- Updated the RuboCop camel case [\#162](https://github.com/rabbitmq/chef-cookbook/pull/162) ([jjasghar](https://github.com/jjasghar))
- Make rabbitmq service restart immediately [\#154](https://github.com/rabbitmq/chef-cookbook/pull/154) ([wenchma](https://github.com/wenchma))
- Adding switch to make TCP listeners optional [\#150](https://github.com/rabbitmq/chef-cookbook/pull/150) ([frankwis](https://github.com/frankwis))
- Add sensitive flag for resources that expose passwords in log [\#148](https://github.com/rabbitmq/chef-cookbook/pull/148) ([kramvan1](https://github.com/kramvan1))
- 141 plugin notify fix [\#142](https://github.com/rabbitmq/chef-cookbook/pull/142) ([caryp](https://github.com/caryp))
- Fix user\_has\_tag? issue when name and tag are the same [\#140](https://github.com/rabbitmq/chef-cookbook/pull/140) ([shunwen](https://github.com/shunwen))

## [v3.3.0](https://github.com/rabbitmq/chef-cookbook/tree/v3.3.0) (2014-08-28)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/v3.2.2...v3.3.0)

**Merged pull requests:**

- test-kitchen updates - porting to serverspec, added cluster suites [\#138](https://github.com/rabbitmq/chef-cookbook/pull/138) ([kennonkwok](https://github.com/kennonkwok))
- update rabbitmq\_policy definition to properly enter params [\#132](https://github.com/rabbitmq/chef-cookbook/pull/132) ([zarry](https://github.com/zarry))
- Make cluster nodes list more deterministic [\#128](https://github.com/rabbitmq/chef-cookbook/pull/128) ([dgivens](https://github.com/dgivens))
- Fix restarts on erlang cookie setting \(again\) [\#120](https://github.com/rabbitmq/chef-cookbook/pull/120) ([kennonkwok](https://github.com/kennonkwok))

## [v3.2.2](https://github.com/rabbitmq/chef-cookbook/tree/v3.2.2) (2014-05-08)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/v3.2.0...v3.2.2)

## [v3.2.0](https://github.com/rabbitmq/chef-cookbook/tree/v3.2.0) (2014-04-24)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/v3.1.0...v3.2.0)

## [v3.1.0](https://github.com/rabbitmq/chef-cookbook/tree/v3.1.0) (2014-03-28)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/v3.0.4...v3.1.0)

## [v3.0.4](https://github.com/rabbitmq/chef-cookbook/tree/v3.0.4) (2014-03-19)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/v3.0.2...v3.0.4)

## [v3.0.2](https://github.com/rabbitmq/chef-cookbook/tree/v3.0.2) (2014-02-28)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/v3.0.0...v3.0.2)

## [v3.0.0](https://github.com/rabbitmq/chef-cookbook/tree/v3.0.0) (2014-02-28)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/v2.4.2...v3.0.0)

## [v2.4.2](https://github.com/rabbitmq/chef-cookbook/tree/v2.4.2) (2014-02-27)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/v2.4.0...v2.4.2)

## [v2.4.0](https://github.com/rabbitmq/chef-cookbook/tree/v2.4.0) (2014-02-14)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/v2.3.2...v2.4.0)

## [v2.3.2](https://github.com/rabbitmq/chef-cookbook/tree/v2.3.2) (2013-10-08)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/v2.3.0...v2.3.2)

**Merged pull requests:**

- \[COOK-3633\] Notify stop, log, and start from the template resource [\#86](https://github.com/rabbitmq/chef-cookbook/pull/86) ([sethvargo](https://github.com/sethvargo))
- \[COOK-3606\] remove trailing \n from erlang cookie file contents [\#84](https://github.com/rabbitmq/chef-cookbook/pull/84) ([portertech](https://github.com/portertech))

## [v2.3.0](https://github.com/rabbitmq/chef-cookbook/tree/v2.3.0) (2013-08-28)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/2.1.2...v2.3.0)

**Merged pull requests:**

- Don't log RabbitMQ passwords. [\#62](https://github.com/rabbitmq/chef-cookbook/pull/62) ([jakedavis](https://github.com/jakedavis))
- Add attribute to bind erlang networking to localhost. [\#46](https://github.com/rabbitmq/chef-cookbook/pull/46) ([abecciu](https://github.com/abecciu))

## [2.1.2](https://github.com/rabbitmq/chef-cookbook/tree/2.1.2) (2013-06-10)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/2.1.0...2.1.2)

**Merged pull requests:**

- Cook 3099 [\#60](https://github.com/rabbitmq/chef-cookbook/pull/60) ([btm](https://github.com/btm))
- COOK-3099 [\#59](https://github.com/rabbitmq/chef-cookbook/pull/59) ([stensonb](https://github.com/stensonb))
- \[COOK-3079\] Use word-boundaries to delimit in permission grep [\#58](https://github.com/rabbitmq/chef-cookbook/pull/58) ([vhata](https://github.com/vhata))
- \[COOK-3078\] Escape and quote password before using [\#57](https://github.com/rabbitmq/chef-cookbook/pull/57) ([vhata](https://github.com/vhata))

## [2.1.0](https://github.com/rabbitmq/chef-cookbook/tree/2.1.0) (2013-05-28)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/2.0.0...2.1.0)

**Merged pull requests:**

- foodcritic  alerts fixes [\#52](https://github.com/rabbitmq/chef-cookbook/pull/52) ([ranjib](https://github.com/ranjib))
- Make clustering work [\#48](https://github.com/rabbitmq/chef-cookbook/pull/48) ([tchoi80](https://github.com/tchoi80))
- \[COOK-2575\] add LWRP for setting policies [\#43](https://github.com/rabbitmq/chef-cookbook/pull/43) ([robertchoi8099](https://github.com/robertchoi8099))

## [2.0.0](https://github.com/rabbitmq/chef-cookbook/tree/2.0.0) (2013-03-22)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/1.8.0...2.0.0)

**Merged pull requests:**

- \[COOK-2391\] Added support for verify verify\_peer and fail\_if\_no\_peer\_cert true [\#38](https://github.com/rabbitmq/chef-cookbook/pull/38) ([portertech](https://github.com/portertech))
- COOK-2211 New way to manage virtualhosts [\#33](https://github.com/rabbitmq/chef-cookbook/pull/33) ([kamaradclimber](https://github.com/kamaradclimber))

## [1.8.0](https://github.com/rabbitmq/chef-cookbook/tree/1.8.0) (2013-01-08)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/1.7.0...1.8.0)

**Merged pull requests:**

- add disk\_free\_limit \(mem\_relative\) and vm\_memory\_high\_watermark settings [\#30](https://github.com/rabbitmq/chef-cookbook/pull/30) ([dcrosta](https://github.com/dcrosta))

## [1.7.0](https://github.com/rabbitmq/chef-cookbook/tree/1.7.0) (2012-12-17)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/1.6.4...1.7.0)

**Merged pull requests:**

- Cook 1850: Add Oracle support to RabbitMQ [\#26](https://github.com/rabbitmq/chef-cookbook/pull/26) ([tas50](https://github.com/tas50))

## [1.6.4](https://github.com/rabbitmq/chef-cookbook/tree/1.6.4) (2012-10-20)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/1.6.2...1.6.4)

**Merged pull requests:**

- COOK-1493 fix system callout to properly determine if plugin is enabled [\#12](https://github.com/rabbitmq/chef-cookbook/pull/12) ([bignastybryce](https://github.com/bignastybryce))

## [1.6.2](https://github.com/rabbitmq/chef-cookbook/tree/1.6.2) (2012-09-17)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/1.6.0...1.6.2)

**Merged pull requests:**

- \[COOK-1552\] removed rogue single quote from rabbitmq ssl configuration [\#18](https://github.com/rabbitmq/chef-cookbook/pull/18) ([portertech](https://github.com/portertech))

## [1.6.0](https://github.com/rabbitmq/chef-cookbook/tree/1.6.0) (2012-09-14)
[Full Changelog](https://github.com/rabbitmq/chef-cookbook/compare/1.5.0...1.6.0)

**Merged pull requests:**

- COOK-1503 Recipe to enable web management console [\#15](https://github.com/rabbitmq/chef-cookbook/pull/15) ([bignastybryce](https://github.com/bignastybryce))
- COOK-1501 Allow installation from yum [\#14](https://github.com/rabbitmq/chef-cookbook/pull/14) ([bignastybryce](https://github.com/bignastybryce))
- apt cookbook 1.4.4 now does this automatically [\#13](https://github.com/rabbitmq/chef-cookbook/pull/13) ([mattray](https://github.com/mattray))

## [1.5.0](https://github.com/rabbitmq/chef-cookbook/tree/1.5.0) (2012-07-12)
**Merged pull requests:**

- COOK-1386 [\#9](https://github.com/rabbitmq/chef-cookbook/pull/9) ([mattray](https://github.com/mattray))
- COOK-1331 adding LWRP for enabling/disabling plugins [\#5](https://github.com/rabbitmq/chef-cookbook/pull/5) ([jschneiderhan](https://github.com/jschneiderhan))
- \[COOK-1219\] immediately restart rabbitmq after changing configuration [\#2](https://github.com/rabbitmq/chef-cookbook/pull/2) ([portertech](https://github.com/portertech))
- Add support for Amazon Linux \(i.e. "amazon"\) [\#1](https://github.com/rabbitmq/chef-cookbook/pull/1) ([jordandm](https://github.com/jordandm))



\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*
