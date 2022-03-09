echo "copy logs to my home folder"
ssh hqvm-jenkins-1 './copy_logs.sh'

echo "copy logs locally"
rsync -av wb@hqvm-jenkins-1:/home/wb/logs/* /home/wb/tools/log_parser/intranet/
