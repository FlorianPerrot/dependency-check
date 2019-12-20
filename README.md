# Dependency check

## Use case

### One shot
You want check dependencies vulerability from your projet with any package manager, see: [compatibility analyzers](https://jeremylong.github.io/DependencyCheck/analyzers/index.html)

```docker run --rm -v `pwd\`:/workdir florianperrot/dependency-check sh -c "dependency-check -s . -f JSON && cat dependency-check-report.json"```

### With Gitlab-ci

```yml
## On .gitlab-ci.yml
Dependency-check:
 image: florianperrot/dependency-check
 script:
 - dependency-check --enableExperimental -s . -f ALL --out reports/
 artifacts:
   paths:
   - reports/
```
