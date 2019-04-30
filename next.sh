#!/bin/bash
# Arquivo para download de Renders Anime


azul_n='\e[01;44m'

branc_n='\e[01;37m'

verde_n='\e[01;32m'

verm_n='\e[01;31m'

res='\e[m'

pasta_exec="Execucoes"

pw=$(pwd)

next_l=300

next_l_v=1

save=$(cat "$pw/Execucoes/save.tur1st4")


_download(){
	cd "$pasta_exec/Principal"

	wget "$PASTE" -O principal.html

	grep 'mtitle' principal.html | sed 's/^.*href=//' | sed 's/><.*//' > urls.txt

	grep "Next" principal.html | sed "s/^.*href='//" | sed "s/'.*//" | sed "s/    var downPage.*;//" | sed '/^$/d' | sed "s/'.*//" >> $pw/Execucoes/Loop/nextld$next_l_v.txt

	cd $pw/Execucoes/Loop
}

_loop(){
	sla=$(wc -l nextld$next_l_v.txt | awk '{print $1}')
		while [[ "$sla" != 0 ]]
		do
			wget -i nextld$next_l_v.txt -O nextll$next_l.html
			let next_l_v=next_l_v+1;
			grep "Next" nextll$next_l.html | sed "s/^.*href='//" | sed "s/'.*//" | sed "s/    var downPage.*;//" | sed '/^$/d' | sed "s/'.*//" >> nextld$next_l_v.txt
			let next_l=next_l-1;
			sla=$(wc -l nextld$next_l_v.txt | awk '{print $1}')
			if [[  $sla == 0 ]]
			then
				break
			fi
		done
}

_render(){
	grep 'mtitle' *.html | sed 's/^.*href=//' | sed 's/><.*//' >> $pw/Execucoes/Principal/urls.txt

	cd ..
	cd ..
	cd $pw/Execucoes/Principal
	grep "'" urls.txt | sed "s/^'//" | sed "s/'.*$//" > urlsd.txt
	pasta_b=$(grep '<center><h1>' principal.html | sed 's/^.*<h1>//' | sed 's/Renders.*//' | sed 's/^.*for //')

	cd $pw/Execucoes/Loop
	wget -i "$pw/Execucoes/Principal/urlsd.txt"
	grep "id='arender'" * | sed 's/^.*href=//' | sed 's/ id.*//' | sed "s/^'//" | sed "s/'.*$//" > download.txt

	cd "$save"
	if [[ -d '$pasta_b' ]]
	then
		cd "$pasta_b"
		wget -i "$pw/Execucoes/Loop/download.txt"
	else
		mkdir "$pasta_b"
		cd "$pasta_b"
		wget -i "$pw/Execucoes/Loop/download.txt"
	fi
	cd $pw
}

_rm(){
	rm Execucoes/Principal/*
	rm Execucoes/Loop/*
}

declare -x _baixar=("Baixando e manipulando os .htmls..."
		    "Baixando e manipulando proximos...."
		    "Baixando as imagens................"
		    "Apagando arquivos desnecessários..."
)

declare -x _comandos=("_download"
		      "_loop"
		      "_render"
		      "_rm"
)

_rodar(){
	{
		while true
		do
			trap "exit" SIGUSR1
		done; } &
		pid=$!
}

_contagem(){
	for n in {0..3}; do
		echo -e "\n"
		echo -en "$branc_n > $res"; echo -en ${_baixar[$n]}
		_rodar

	sleep 2; eval ${_comandos[$n]} >> erro.fodeu 2>erro.fodeu

	if [[ "$?" == "0" ]]
	then
		echo -en "$verde_n [ok]$res"
		rm erro.fodeu
		kill -USR1 $pid
		wait $pid
		trap EXIT
	else
		echo -en "$verm_n [erro]$res"
		setterm -cursor on
		kill -USR1 $pid
		trap EXIT
		exit $?
	fi
	done
}

_loop_p(){
	if [[ $LOOP == @(S|s|Sim|sim|SIM) ]]
	then
		$pw/main.sh
	elif [[ $LOOP == @(N|n|Nao|nao|NAO|Não|não|NÃO) ]]
	then
		clear
		echo -e "\nO script foi finalizado com sucesso! ^-^\n"
                setterm -cursor on
                exit 0
	else
		echo -e "\n"
		echo -e "Não cosegui entender..."
		echo -e "$branc_n\nDeseja fazer outro download? [S/N]\c$res"
		read LOOP
		_loop_p
	fi
}


echo -e "\n$branc_n Cole aqui a url: $res\c"
read PASTE

clear

_contagem

#_download

#_loop

#rodar

echo -e "\n"

echo -e "$verde_n >>$res O seu download foi concluido com sucesso! $verde_n<< $res"

echo -e "\n"

echo -e "$branc_n Deseja fazer outro download? [S/N]\c$res"
read LOOP

_loop_p

exit 0