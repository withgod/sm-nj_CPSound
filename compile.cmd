set TF2_BASE=C:/contents/gameserver/tf2_1/orangebox/tf

%TF2_BASE%/addons/sourcemod/scripting/spcomp.exe ./addons/sourcemod/scripting/nj_CPSound.sp -o./addons/sourcemod/plugins/nj_CPSound.smx

tar czvf ./nj_CPSound.tar.gz ./addons ./sound

tar zxvf ./nj_CPSound.tar.gz -C %TF2_BASE%

@rem pause
