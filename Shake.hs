import Development.Shake

-- shakeFiles testes shake to make .shake in dist-newstyle
main = shakeArgs shakeOptions{shakeFiles=".stack-work"} $ do
    want ["push"]

    phony "push" $ do
      () <- cmd "git stash save"
      () <- cmd "git checkout gh-pages"
      () <- liftIO $ removeFiles "." ["*.html"] -- remove index
      () <- liftIO $ removeFiles "images" ["*.png"] -- remove images
      () <- liftIO $ removeFiles "posts" ["*.html"] -- remove posts
      () <- liftIO $ removeFiles "css" ["*.css"] -- remove css
      () <- cmd "cp -ar ./_/site/. ."
      () <- liftIO $ removeFiles "_cache" ["//*"]
      () <- liftIO $ removeFiles "_site" ["//*"]
      () <- cmd "git add ."
      () <- cmd "git commit"
      () <- cmd "git push"
      () <- cmd "git checkout master"
      cmd "git stash pop"
