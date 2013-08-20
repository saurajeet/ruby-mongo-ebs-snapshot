ruby-mongo-ebs-snapshot
=======================
  
Backing Up Mongo as EBS snapshots
    
Backup Users Access Key Should have an IAM  Policy like the following.
    
    {
      "Version": "<some version number>",
      "Statement": [
        {
          "Action": [
            "ec2:CreateSnapshot",
            "ec2:CreateTags",
            "ec2:CreateVolume",
            "ec2:DeleteSnapshot",
            "ec2:DeleteTags",
            "ec2:DeleteVolume",
            "ec2:DescribeInstanceAttribute",
            "ec2:DescribeInstanceStatus",
            "ec2:DescribeInstances",
            "ec2:DescribeRegions",
            "ec2:DescribeSnapshotAttribute",
            "ec2:DescribeSnapshots",
            "ec2:DescribeTags",
            "ec2:DescribeVolumeAttribute",
            "ec2:DescribeVolumeStatus",
            "ec2:DescribeVolumes",
            "ec2:ImportVolume",
            "ec2:ModifyInstanceAttribute",
            "ec2:ModifySnapshotAttribute",
            "ec2:ModifyVolumeAttribute",
            "ec2:ResetSnapshotAttribute"
          ],
          "Sid": "<some_sid>",
          "Resource": [
            "*"
          ],
          "Effect": "Allow"
        }
      ]
    }
    
Installation
------------
Create a config file in conf/settings.yml

    access_key: AAAAAAAAZZZZZZZZ
    secret_key: AAAAAAAAABBBBBBBBBBBBBCCCCCCCCCCCCCCDDDDD
    region: us-east-1
    device: /dev/sdh
    mongo_port: 27017
    admin_user: admin
    admin_pass: <PASS>
    run_if: not_master 
    desc: lorem ipsum 

run_if checks server is not master. Should be used to set so that if quorum fails and the backup host is elected as primary. The backup should stop. Use the mongo options properly to avoid using this option. 

desc are the descriptions to be added to the snapshot
