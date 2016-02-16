# chatops_deployer

This cookbooks automates the set up of the following apps on an Ubuntu box:

1. chatops_deployer
2. docker_auto_build
3. hubot - todo
4. private docker registry - todo
5. frontail - todo

## Testing

On a box with vagrant and chefdk,

```
$ kitchen converge # Runs the chef recipe
$ kitchen verify # Runs tests to verify the state after converging
```
