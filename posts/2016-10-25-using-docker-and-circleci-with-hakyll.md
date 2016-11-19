---
title: Using Docker and CircleCI with Hakyll
author: Ryan Desfosses
---

Juan Pedro Villa published a great article ([Dr. Hakyll: Create a GitHub page with Hakyll and CircleCI](https://www.stackbuilders.com/news/dr-hakyll-create-a-github-page-with-hakyll-and-circleci)) explaining how to use circleci to provide continuous deliver for a hakyll site.

However, I ran into some trouble with circleci.  My builds kept timing out or I'd get a cabal build error.  So I figured I should take advantage of circleci's docker support.

I started off with a simple docker image that has every thing I need to build the site.

```
FROM rdesfo/stack:latest
Maintainer Ryan Desfosses <ryan@desfo.org>

RUN stack setup --compiler ghc-7.10.3

RUN stack install --resolver lts-6.25 hakyll
```

Now that I have the docker image I can use the same git repo that I setup following Juan outlined in his article.  The only difference I ran into was that I had to add	a `-f` to the submodule command since I had added `_site` to my `.gitignore` file.

``` bash
git submodule add -f https://github.com/rdesfo/hakyll-test.git _site
```

The next step was to tell circleci to use docker to carry out the build steps.  I started out with the following, but came to find out that circleci doesn't currently support `docker exec`. 

``` yaml
machine:
  services:
    - docker

dependencies:
  override:
    - docker pull rdesfo/hakyll

test:
  override:
    - docker run -d --name hakyll -i rdesfo/hakyll bash
    - docker cp . hakyll:/home/user/app/
    - docker exec -u root hakyll chown -R user:user /home/user/app
    - docker exec -u user hakyll sh -c "cd /home/user/app; stack build; stack exec -- site build"
```

Fortunately, circleci has some great [documentation](https://circleci.com/docs/docker/#docker-exec) that provides a work around.  It's not pretty, but I was able to replace `docker exec` with the following `lxc-attach`.

```
 - sudo lxc-attach -n "$(docker inspect --format "{{.Id}}" hakyll)" -- bash -c "chown -R user:user /home/user/app"
    - sudo lxc-attach -n "$(docker inspect --format "{{.Id}}" hakyll)" -- su user - bash -c "export LANG='C.UTF-8'; cd /home/user/app; stack build; stack exec -- site build"
```

The full circleci yaml file can be found [here](https://github.com/rdesfo/desfo.github.io/blob/master/circle.yml).