#!/usr/bin/bash
#set -x
design_doc()
{
a="sk-H8D3LLvmzJW5MLN35"
b="yppT3BlbkFJgZjtZ38o0"
c="R2DnDt3FENp"
api_key=$a$b$c
curl --silent $url \
		-H "Authorization: Bearer $api_key" \
		-H "Content-Type: application/json" \
		-d "{
		     \"model\": \"gpt-3.5-turbo\",
	    	     \"messages\": [{\"role\": \"user\", \"content\": \"$1\n$2\"}],
		     \"temperature\": 0.5
	            }" 
}
url=https://api.openai.com/v1/chat/completions
#repo_name="./code_conversion/"
repo_name="./designscript/"
cd $repo_name
file_list=(`find . -name GetAccountDetails.xml`)
#echo ${file_list[*]}
file_content=`cat ${file_list[*]}|grep -v '//'|tr '\r\n' ' '|sed 's/\"/\\\"/g'`
cd "../designscript"
prompt=`cat ./prompt.txt|sed ':a;N;$!ba;s/\n/\\\n/g'|sed 's/\"/\\\"/g'`
#design_doc "$prompt" "$file_content"|sed -e 's/\\n/\n/g' -e 's/\\\"/\"/g' -e 's/\\t/	/g'
design_doc "$prompt" "$file_content" > des_input.json
w_count=$(cat des_input.json|wc -c)
des_var=$(cat des_input.json |awk -v RS="\"content\": \"" 'NR>1 {print $0}'|awk -v RS="\"finish_reason\": \"stop\"" 'NR==1 {print $0}'|awk 'NR==1 {print $0}'|cut -c -$((w_count-3)))
#echo "${des_var//'\n'/$'\n'}"|sed ':a;N;$!ba;s/\n/\\\n/g'|sed 's/\"/\\\"/g'
echo "${des_var//'\n'/$'\n'}"

