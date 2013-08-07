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
    
    
    
