import Development.Shake


-- shakeFiles testes shake to make .shake in dist-newstyle
main = shakeArgs shakeOptions{shakeFiles="dist-newstyle"} $ do
    want ["push"]

    phony "push" $ do
      () <- cmd "git checkout gh-pages"
      () <- removeFiles "test" ["*"]
      cmd "ls"

