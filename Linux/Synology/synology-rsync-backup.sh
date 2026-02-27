#!/bin/bash
rsync --archive --verbose --update --log-file=/volume1/FamilyPhoto/rsync_$(date +'%Y.%m.%d').log /volume1/Entisys360/ ubuntu-admin@10.103.22.203:~/docker-nvme01/Entisys360 && curl -fsS --retry 3 http://10.103.22.202:3001/api/push/Zh3x2a4mPY?status=up&msg=OK&ping=
