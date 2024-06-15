# Author Hugo Andrés Vázquez
# It is recomended to create a daily crojob with this
# Download cloudflare list
wget https://www.cloudflare.com/ips-v4


STATUS="$(cmp --silent ips-v4 ips-v4-golden; echo $?)"  # "$?" comparison result

if [[ $STATUS -ne 0 ]]; then  # if status isn't equal to 0, then execute code

echo "IP range CHANGED!"
# Security grooup to update
SG_ID="sg-00000000000000"

# desde la lista ejecutar esto por cada subnet detectada y agregar puerto 80 y 443

while read p
do
    aws ec2 authorize-security-group-ingress --group-id $SG_ID --ip-permissions IpProtocol=tcp,FromPort=80,ToPort=80,IpRanges="[{CidrIp=$p,Description='Cloudflare'}]"
    aws ec2 authorize-security-group-ingress --group-id $SG_ID --ip-permissions IpProtocol=tcp,FromPort=443,ToPort=443,IpRanges="[{CidrIp=$p,Description='Cloudflare'}]"
done< ips-v4 


#mover archivo ejecutado
mv ips-v4 ips-v4-golden


else
    echo "IP range unchanged"
    rm ips-v4
fi
echo "Thats all Folks"

