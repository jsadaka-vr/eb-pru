import boto3
import chaoslib
from chaoslib.exceptions import ActivityFailed


def get_aws_client(arn, region, kind, endpoint=None):
    sts_client = boto3.client("sts")

    stsresponse = sts_client.assume_role(
        RoleArn=arn, RoleSessionName="experiment-broker"
    )
    requested_client = boto3.client(
        kind,
        region=region,
        aws_access_key_id=stsresponse["Credentials"]["AccessKeyId"],
        aws_secret_access_key=stsresponse["Credentials"]["SecretAccessKey"],
        aws_session_token=stsresponse["Credentials"]["SessionToken"],
        endpoint_url=endpoint,
    )
    return requested_client


def get_aws_resource(arn, region, kind, endpoint=None):
    sts_client = boto3.client("sts")

    stsresponse = sts_client.assume_role(
        RoleArn=arn, RoleSessionName="experiment-broker"
    )
    requested_client = boto3.resource(
        kind,
        region=region,
        aws_access_key_id=stsresponse["Credentials"]["AccessKeyId"],
        aws_secret_access_key=stsresponse["Credentials"]["SecretAccessKey"],
        aws_session_token=stsresponse["Credentials"]["SessionToken"],
        endpoint_url=endpoint,
    )
    return requested_client
