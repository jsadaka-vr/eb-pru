# Resiliency Extension

This project is a collection of [actions][] and [probes][], gathered as an
extension to the [Chaos Toolkit][chaostoolkit].

[actions]: https://chaostoolkit.org/reference/api/experiment/#action
[probes]: https://chaostoolkit.org/reference/api/experiment/#probe
[chaostoolkit]: https://chaostoolkit.org

## Usage

```json
{
    "name": "disable-az",
    "provider": {
        "type": "python",
        "module": "resiliency.az.actions",
        "func": "disable_az",
        "arguments": {
            "availability_zone": "us-east-1a"
        }
    }
}
```

Or

```yaml
---
version: 1.0.0
title: AZ failure
description: Simulate AZ failure
method:
  - type: action
    provider:
      type: python
      module: resiliency.az.actions
      func: disable_az
      arguments:
        availability_zone: ${availability_zone}
```

That's it!

Please explore the code to see existing probes and actions.

## Configuration

### Credentials

This extension uses the [boto3][] library under the hood. This library expects
that you have properly [configured][creds] your environment to connect and
authenticate with the AWS services.

[boto3]: https://boto3.readthedocs.io
[creds]: https://boto3.readthedocs.io/en/latest/guide/configuration.html

### Assume an ARN role from a non-default profile

Assuming you have configured a profile in your `~/.aws/config` file with
a specific [ARN role][role] you want to assume during the run, you may
declare it in your experiment as follows:

[role]: https://boto3.readthedocs.io/en/latest/guide/configuration.html#aws-config-file

```json
{
    "configuration": {
        "aws_profile_name": "dev"
    }
}
```

Your `~/.aws/config` should look like this:

```
[default]
output = json

[profile dev]
role_arn = arn:aws:iam::XXXXXXX:role/role-name
source_profile = default
```

### Assume an ARN role from within the experiment

You may also assume a role by declaring the role ARN in the experiment
directly. In that case, the profile has no impact if you also set it.

```json
{
    "configuration": {
        "aws_assume_role_arn": "arn:aws:iam::XXXXXXX:role/role-name",
        "aws_assume_role_session_name": "my-chaos"
    }
}
```

The `aws_assume_role_session_name` key is optional and will be set to
``ChaosToolkit`` when not provided.

When this approach is used, the extension performs a [assume role][assumerole]
call against the [AWS STS][sts] service to fetch credentials dynamically.

[assumerole]: https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/sts.html#STS.Client.assume_role
[sts]: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_temp_request.html

### Setting the Region

In addition to the authentication credentials, you must configure the region
against which you want to use.

You can either declare it at the top level of the experiment, add:

```json
{
    "configuration": {
        "aws_region": "us-east-1"
    }
}
```

or

```json
{
    "configuration": {
        "aws_region": {
            "env": "type",
            "key": "AWS_REGION"
        }
    }
}
```

Or you can also simple set either `AWS_REGION` or `AWS_DEFAULT_REGION` in
your terminal session without declaring anything in the experiment.

If none of these are set, your experiment will likely fail.

## Contribute

If you wish to contribute more functions to this package, you are more than
welcome to do so. Please make any changes following the usual [PEP 8][pep8]
code style, sprinkling with tests and submit a PR for review.

[pep8]: https://pycodestyle.readthedocs.io/en/latest/

### Develop

If you wish to develop on this project, make sure to install the development
dependencies. But first, [create a virtual environment][venv] and then install
those dependencies.

[venv]: https://chaostoolkit.org/reference/usage/install/#create-a-virtual-environment

```console
$ pip install -r requirements-dev.txt -r requirements.txt
```

Then, point your environment to this directory:

```console
$ python setup.py develop
```

Now, you can edit the files and they will be automatically seen by your
environment, even when running from the `chaos` command locally.

### Test

To run the tests for the project execute the following:

```console
$ pytest
```

### Add new AWS API Support

Once you have setup your environment, you can start adding new
[AWS API support][awsapi] by adding new actions, probes and entire sub-packages
for those.

[awsapi]: https://boto3.readthedocs.io/en/latest/reference/services/index.html

#### Services supported by boto

This package relies on [boto3][] to wrap the API calls into a fluent Python
API. Some newer AWS services are not yet available in boto3, in that case,
you should read the next section.

[boto3]: https://boto3.readthedocs.io/en/latest/reference/services/index.html

Let's say you want to support a new action in the EC2 sub-package.

Start by creating a new function in `ec2/actions.py`:

```python
from chaoslib.types import Configuration, Secrets

from chaosaws import aws_client
from chaosaws.types import AWSResponse

def reboot_instance(instance_id: str, dry_run: bool=False,
                    configuration: Configuration=None,
                    secrets: Secrets=None) -> AWSResponse:
    """
    Reboot a given EC2 instance.
    """
    client = aws_client('ec2', configuration, secrets)
    return client.reboot_instances(InstanceIds=[instance_id], DryRun=dry_run)
```

As you can see, the actual code is straightforward. You first create a
[EC2 client][ec2client] and simply call the appropriate method on that client
with the expected arguments. We return the action as-is so that it can be
logged by the chaostoolkit, or even be used as part of a steady-state
hypothesis probe (if this was a probe, not action that is).

You could decide to make more than one AWS API call but, it is better to keep
it simple so that composition is easier from the experiment. Nonetheless,
you may also compose those directly into a single action as well for specific
use-cases.

Please refer to the Chaos Toolkit documentation to learn more about the
[configuration][] and [secrets][] objects.

[ec2client]: https://boto3.readthedocs.io/en/latest/reference/services/ec2.html#client
[configuration]: http://chaostoolkit.org/reference/api/experiment/#configuration
[secrets]: http://chaostoolkit.org/reference/api/experiment/#secrets

Once you have implemented that action, you must create at least one unit test
for it in the `tests/ec2/test_ec2_actions.py` test module. For example:

```python
from resiliency.ec2.actions import reboot_instance

@patch('resiliency.ec2.actions.aws_client', autospec=True)
def test_reboot_instance(aws_client):
    client = MagicMock()
    aws_client.return_value = client
    inst_id = "i-1234567890abcdef0"
    response = reboot_instance(inst_id)
    client.reboot_instances.assert_called_with(
        InstanceIds=[inst_id], DryRun=False)
```

By using the [built-in Python module to mock objects][pymock], we can mock the
EC2 client and assert that we do indeed call the appropriate method with the right
arguments. You are encouraged to write more than a single test for various
conditions.

[pymock]: https://docs.python.org/3/library/unittest.mock.html#module-unittest.mock

Finally, should you choose to add support for a new AWS API resource altogether,
you should create the according sub-package.

#### Services not supported by boto (new AWS features)

If the support you want to provide is for a new AWS service that [boto][] does
not support yet, this requires direct call to the API endpoint via the
[requests][] package. Say we have a new service, not yet supported by boto3

[eks]: https://aws.amazon.com/eks/
[boto]: https://boto3.readthedocs.io/en/latest/index.html
[requests]: http://docs.python-requests.org/en/master/

```python
from chaoslib.types import Configuration, Secrets

from chaosaws import signed_api_call
from chaosaws.types import AWSResponse

def terminate_worker_node(worker_node_id: str,
                          configuration: Configuration=None,
                          secrets: Secrets=None) -> AWSResponse:
    """
    Terminate a worker node.
    """
    params = {
        "DryRun": True,
        "WorkerNodeId.1": worker_node_id
    }
    response = signed_api_call(
        'some-new-service-name', path='/2018-01-01/worker/terminate',
        method='POST', params=params,
        configuration=configuration, secrets=secrets)
    return response.json()
```

Here is an example on existing API call (as a more concrete snippet):

```python
from chaoslib.types import Configuration, Secrets

from chaosaws import signed_api_call

def stop_instance(instance_id: str, configuration: Configuration=None,
                  secrets: Secrets=None) -> str:
    response = signed_api_call(
        'ec2',
        configuration=configuration,
        secrets=secrets,
        params={
            "Action": "StopInstances",
            "InstanceId.1": instance_id,
            "Version": "2013-06-15"
        }
    )

    # this API returns XML, not JSON
    return response.text
```

When using the `signed_api_call`, you are responsible for the right way of
passing the parameters. Basically, look at the AWS documentation for each
API call.

**WARNING:** It should be noted that, whenever boto3 implements an API, this
package should be updated accordingly, as boto3 is much more versatile and
solid.

#### Make your new sub-package discoverable

Finally, if you have created a new sub-package entirely, you need to make its
capability discoverable by the chaos toolkit. Simply amend the `discover`
function in the `resiliency/__init__.py`. For example, assuming a new `eks`
sub-package, with actions and probes:

```python
    activities.extend(discover_actions("resiliency.eks.actions"))
    activities.extend(discover_probes("resiliency.eks.probes"))
```
