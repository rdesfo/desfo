---
title: Using Docker and CircleCI with Hakyll
author: Ryan Desfosses
---


Juan Pedro Villa published a great article ([Dr. Hakyll: Create a GitHub page with Hakyll and CircleCI](https://www.stackbuilders.com/news/dr-hakyll-create-a-github-page-with-hakyll-and-circleci)) explaining how to use circleci to providing contineous deliver for a hakyll site.



use docker container

```
SHOW container
```

use hakyll-test as example

``` bash
git submodule add -f https://github.com/rdesfo/hakyll-test.git _site
```

need to add `-f` to force the submodule since the `_site` folder is in the ignore list.


## Generate site

``` bash
docker run -d --name hakyll -i rdesfo/hakyll bash
docker cp . hakyll:/home/user/app/
docker exec -u root hakyll chown -R user:user /home/user/app
docker exec -u user hakyll sh -c "cd /home/user/app; stack build; stack exec -- site build"
docker cp hakyll:/home/user/app/_site
```

FAILS  --- CIRCLECI DOESN'T SUPPORT 'DOCKER EXEC'
