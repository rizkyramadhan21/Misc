-- -------------------------------------------------------------
-- Plugin registrasi user notifikasi ATM to database your_host 
-- Rizky Ramadhan,  June 13, 2017
-- Last Update :    June 17, 2017
-- implementation registration atm notif to @jak3bot
-- -------------------------------------------------------------

run = (msg,matches) ->   


  target = matches[1]\upper()                                                          
  waktu = io.popen("echo -n `date +'%d-%m-%Y_%H:%M'`")\read('*all')                     
  name = msg.from.first_name                                                          
  name ..= " #{msg.from.last_name}" if msg.from.last_name                             
  user = msg.from.username                                                             
  id = msg.chat.id                                                                     


------------------------------------------------------------
-- Table structures databases mantab: 
-- (telegram_id | telegram_name | branchcode | notification)
-- ---------------------------------------------------------
 
  if msg.text\match "^!unreg atm (%d+)$"        --//Unreg ATM Notifications [delete from mantel.db | table: mantab and notif1 ]
    print matches[1]
    branch = matches[1]
    uname = io.popen("echo '#{name}' | sed 's/ /_/g;' | tr -d '\n'")\read('*all')
    strCommand = io.popen("echo 'mysql --host=your_host --user=root --password=your_password mantel << EOF\nDELETE from notif1 WHERE telegram_id=#{id} and branchcode=#{branch}\nEOF' > ~/tmp/unregATM.sh")\read('*all')
    strCoMantab = io.popen("echo 'mysql --host=your_host --user=root --password=your_password mantel << EOF\nDELETE from mantab WHERE telegram_id=#{id}\nEOF' > ~/tmp/unregATMmantab.sh")\read('*all')
    execCommand = io.popen("cd ~/tmp/; chmod +x unregATM.sh; ./unregATM.sh")\read('*all')
    execCoMantab = io.popen("cd ~/tmp/; chmod +x unregATMmantab.sh; ./unregATMmantab.sh")\read('*all')
    perintah = io.popen("echo '*Unreg Notifikasi ATM*:\n\nTelegram Name: #{name}\nTelegram ID: #{id}\nBranch Code: #{branch}\nStatus: _inactive_\n\nTerima kasih.'")\read('*all')
    telegram!\sendMessage msg.chat.id,perintah,msg.message_id,"Markdown"
    return



  if msg.text\match "^!reg atm (%d+)$"          --//Reg ATM Notifications [insert into mantel.db | table: mantab and notif1 ]
    print matches[1]
    branch = matches[1]
    telecode = io.popen("echo '#{id}#{branch}' | tr -d '\n'")\read('*all')
    uname = io.popen("echo '#{name}' | sed 's/ /_/g;' | tr -d '\n'")\read('*all')
    unameBranch = io.popen("echo '#{branch} #{name}' | sed 's/ /_/g;' | tr -d '\n'")\read('*all')
    strCommand = io.popen("echo 'mysql --host=your_host --user=root --password=your_password mantel << EOF\ninsert into notif1 (telegram_id,branchcode,telecode,active) values\n(#{id},kutip#{branch}kutip,kutip#{telecode}kutip,1);\nEOF' | ~/tmp/kutip.sh > ~/tmp/regATM.sh")\read('*all')
    execCommand = io.popen("cd ~/tmp/; chmod +x regATM.sh; ./regATM.sh")\read('*all')
    strCoMantab = io.popen("echo 'mysql --host=your_host --user=root --password=your_password mantel << EOF\ninsert into mantab (telegram_id,telegram_name,branchcode,notification) values\n(#{id},kutip#{unameBranch}kutip,kutip#{branch}kutip,1);\nEOF' | ~/tmp/kutip.sh > ~/tmp/regATMmantab.sh")\read('*all')
    execCoMantab = io.popen("cd ~/tmp/; chmod +x regATMmantab.sh; ./regATMmantab.sh")\read('*all')
    perintah = io.popen("echo 'Terima kasih telah mendaftar sebagai penerima *Notifikasi ATM*:\n\nTelegram Name: #{name}\nTelegram ID: #{id}\nBranch Code: #{branch}\n\nSilahkan tunggu _Job_ Notifikasi selanjutnya!\nTerima kasih.'")\read('*all')
    telegram!\sendMessage msg.chat.id,perintah,msg.message_id,"Markdown"
    return



return {
  description: "*Registrasi Plugins*"
  usage: "!reg atm [kode cabang]
  		  !unreg atm [kode cabang]"
  patterns: {

  "^!reg atm (%d+)$"
  "^!unreg atm (%d+)$"
  }
  :run
}
