#Dear future self,
#
#You're looking at this file because
#the parse function finally broke.
#
#It's not fixable. You have to rewrite it.
#Sincerely, past self.
#
#Also it's probably at least
#2017, did you ever take
#that trip to Iceland?
  
num=`grep -n custom_binary/debug=\"\" export.cfg | head -1 | awk -F: '{ print $1}'`; sed -i "1,${num}s+custom_binary/debug=\"\"+custom_binary/debug=\"../template.x32\"+" export.cfg
num=`grep -n custom_binary/debug=\"\" export.cfg | head -1 | awk -F: '{ print $1}'`; sed -i "1,${num}s+custom_binary/debug=\"\"+custom_binary/debug=\"../template.exe\"+" export.cfg
num=`grep -n custom_package/debug=\"\" export.cfg | head -1 | awk -F: '{ print $1}'`; sed -i "1,${num}s+custom_package/debug=\"\"+custom_package/debug=\"../template.apk\"+" export.cfg
num=`grep -n custom_package/debug=\"\" export.cfg | head -2 | tail -1 | awk -F: '{ print $1}'`; sed -i "1,${num}s+custom_package/debug=\"\"+custom_package/debug=\"../template.zip\"+" export.cfg
 
