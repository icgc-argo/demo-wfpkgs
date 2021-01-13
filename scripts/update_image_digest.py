#!/usr/bin/env python3

# this is a temporary solution

import argparse
import json


def update_image_digest(package_meta, checksum_type, checksum, utc_time):
    with open(package_meta, 'r') as f:
        meta = json.load(f)

    meta['container']['_image_digest'] = {
        "created": utc_time,
        "checksum_type": checksum_type,
        "checksum": checksum
    }

    return meta


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Update docker image digest in package release JSON')
    parser.add_argument('-p', dest='package_meta', type=str, required=True)
    parser.add_argument('-t', dest='checksum_type', type=str, required=True)
    parser.add_argument('-c', dest='checksum', type=str, required=True)
    parser.add_argument('-u', dest='utc_time', type=str, required=True)
    args = parser.parse_args()

    updated_meta = update_image_digest(
        args.package_meta,
        args.checksum_type,
        args.checksum,
        args.utc_time,
    )

    print(json.dumps(updated_meta, indent=4))
