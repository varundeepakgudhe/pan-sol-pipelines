PREF=Squi2.bnx.210622
DIR=`pwd`
./generate_site_positions.py Arima $PREF.sites references/$PREF.fasta
./scripts/juicer.sh -z ./references/$PREF.fasta -s Arima -D $DIR -t 24 -p ./references/$PREF.fasta.sizes -y $PREF.sites_Arima.txt -g $PREF
