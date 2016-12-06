---
title: Enabling Docker's User Namespaces in Nixos
author: Ryan Desfosses
---

Docker has had the ability to run a root user in a container with expected administrative
privileges while also mapping the same user to an unprivileged uid on host since 1.10.

This can be enabled in NixOS by simply adding a few lines to the _configuration.nix_ file,
`nixos-rebuild`, and `reboot`. 


``` nix
  virtualisation.docker.extraOptions = "--userns-remap=default";

...
...

  users.groups.dockremap.gid = 10000;

  users.users = {
    dockremap = {
      isSystemUser = true;
      uid = 10000;
      group = "dockremap";
      subUidRanges = [
        { startUid = 100000; count = 65536; }
      ];
      subGidRanges = [
        { startGid = 100000; count = 65536; }
      ];
    };
  };
```

The first line tells docker daemon to enable the user namespace support.
The following lines are used to create _/etc/subuid_ and _/etc/subgid_ files.
More information regarding user namespace feature as well as some known restriction
can be found in the 
[dockerd docs](https://docs.docker.com/engine/reference/commandline/dockerd/#daemon-user-namespace-options)
