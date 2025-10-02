import os
import ssl
import socket
from datetime import datetime
import boto3
import certifi

HOST = os.environ['HOST']
PORT = 443
DAYS = 20

sns = boto3.client('sns')
topic_arn = os.environ['SNS_TOPIC_ARN']


def lambda_handler(event, context):
    context = ssl.create_default_context(cafile=certifi.where())
    with socket.create_connection((HOST, PORT)) as sock:
        with context.wrap_socket(sock, server_hostname=HOST) as ssock:
            cert = ssock.getpeercert()
            not_after = cert['notAfter']
            expires = datetime.strptime(not_after, '%b %d %H:%M:%S %Y %Z')
            days_left = (expires - datetime.now()).days

            if days_left < DAYS:
                sns.publish(TopicArn=topic_arn, Message=f'WARNING: Certificate for {HOST} expires in {days_left} days!')

                print(f'WARNING: Certificate for {HOST} expires in {days_left} days!')
            else:
                print(f'Certificate for {HOST} is valid for {days_left} more days.')

if __name__ == '__main__':
    lambda_handler(None, None)