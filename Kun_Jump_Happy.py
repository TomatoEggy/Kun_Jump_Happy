import pgzrun,random
from os import getenv,makedirs
from shutil import copyfile

VERSION='4.0'
TITLE='坤 坤 跳 跳 乐 '+VERSION
WIDTH=950
HEIGHT=300
GAMEINFO={}

jump=0
score=0
games=0
basks=0
squat=0
invincible=0
hp=0
oilCakeS=False
settingsfile=open('SETTINGS','r',encoding='utf-8')
settings=settingsfile.read().split('\n')
settingsfile.close()
musicbg=settings[0]
debug=int(settings[1])
maxscores=int(settings[2])

def percent(num):
    n=random.randint(0,1999)
    if n<num:
        return True
    else:
        return False

def gameover():
    global games
    games=2
    sounds.gameover.play()

road1=Actor('road1')
road2=Actor('road2')

cloud1=Actor('cloud')
cloud2=Actor('cloud')
cloud3=Actor('cloud')
clouds=[cloud1,cloud2,cloud3]

basketry1=Actor('basketry')
basketry2=Actor('basketry')

bg=Actor('background')

restartbutton=Actor('button')
exitbutton=Actor('button')
startbutton=Actor('button')
settingsbutton=Actor('button')
musicbutton=Actor('button')
debugbutton=Actor('button')
exitsettingsbutton=Actor('button')

kun=Actor('kunkun')

basketball1=Actor('basketball')
basketball2=Actor('basketball')

sun1=Actor('sun')
sun2=Actor('sun')

oilCake=Actor('oil_cake')

easyButton=Actor('button')
midButton=Actor('button')
hardButton=Actor('button')
veryHardButton=Actor('button')
easyButton.pos=[250,75]
midButton.pos=[650,75]
hardButton.pos=[250,195]
veryHardButton.pos=[650,195]

basketballY=[240,200,145]
startbutton.pos=[330,225]
settingsbutton.pos=[570,225]
musicbutton.pos=[350,150]
debugbutton.pos=[600,150]
exitsettingsbutton.pos=[470,250]

def init(mode : str):
    global games,jump,score,basks,basketballY,settingsfile,settings,musicbg,debug,maxscores,invincible,hp,oilCakeS,GAMEINFO
    
    modeinfo={
        'esay':[8,random.randint(870,1000),10,8,5,4],
        'mid':[6,random.randint(700,850),5,9,3,2],
        'hard':[4,random.randint(550,675),2,11,2,1],
        'veryHard':[4,random.randint(450,500),0,13,1,0]
    }

    GAMEINFO={
        'mode':mode,
        'loop':modeinfo[mode][0],
        'interval':modeinfo[mode][1],
        'inviChance':modeinfo[mode][2],
        'speed':modeinfo[mode][3],
        'hp':modeinfo[mode][4],
        'oilCakeChance':modeinfo[mode][5]
    }

    road1.x,road1.top=475,250
    road2.x,road2.top=[road1.x+950,250]

    cloud1.pos=[1000,random.randint(30,130)]
    cloud2.pos=[cloud1.x+350,random.randint(30,130)]
    cloud3.pos=[cloud2.x+350,random.randint(30,130)]

    basketry1.pos=[1100,240]
    basketry2.pos=[basketry1.x+GAMEINFO['interval'],240] 

    bg.pos=[475,150]  

    restartbutton.pos=[330,235]    
    exitbutton.pos=[570,235]

    kun.pos=[85,225]

    basketballY=[220,200,145]

    if percent(GAMEINFO['inviChance']):
        basketball1.pos=[940,basketballY[2]]
        basketball2.pos=[basketball1.x+GAMEINFO['interval'],basketballY[2]]
    else:
        basketball1.pos=[940,basketballY[random.randint(0,1)]]
        basketball2.pos=[basketball1.x+750,basketballY[random.randint(0,1)]]

    sun1.pos=[random.randint(80,910),-10]
    sun2.pos=[random.randint(80,910),-10]

    oilCake.pos=[1050,basketballY[2]]

    kun.image='kunkun'

    basks=0
    games=1
    jump=0
    score=0
    oilCakeS=False
    hp=GAMEINFO['hp']

    settingsfile=open('SETTINGS','r',encoding='utf-8')
    settings=settingsfile.read().split('\n')
    settingsfile.close()

    musicbg=settings[0]
    debug=int(settings[1])
    maxscores=int(settings[2])

    invincible=0

def reduceHealth():
    global hp,invincible
    if hp!=0:
        hp-=1
        invincible=1
        if hp!=0:
            sounds.reducehealth.play()
    if hp==0:
        gameover()

def draw():
    global score,games,health,basks,debug,squat,musicbg,maxscores,invincible,hp,oilCakeS
    if games==1:
        screen.fill((222,250,255))
        road1.draw()
        road2.draw()
        for c in clouds:
            c.draw()
        screen.draw.text('你的得分：'+str(score),[20,10],color='black',fontname='smiley_sans')
        screen.draw.text('你的血量：'+str(hp),[20,40],color='red',fontname='smiley_sans')
        if basks==0:
            basketry2.draw()
            if score!=(score//GAMEINFO['loop']+1)*GAMEINFO['loop']-1 or score==0:
                basketry1.draw()   
        kun.draw()
        oilCake.draw()
        if basks==1:
            basketball2.draw()
            if score!=(score//GAMEINFO['loop']+1)*GAMEINFO['loop']-1:
                basketball1.draw()
        if basks==2:
            sun1.draw()
            sun2.draw()
    elif games==2:
        bg.draw()
        screen.draw.text('你失败了',[305,45],color='red',fontsize=90,fontname='smiley_sans')
        if score>maxscores:
            screen.draw.text('新纪录！',[385,10],color='red',fontsize=35,fontname='smiley_sans')
            settingsfile=open('SETTINGS','w',encoding='utf-8')
            settingsfile.write(musicbg+'\n'+str(debug)+'\n'+str(score))
            settingsfile.close()
        screen.draw.text('你的得分：'+str(score),[360,145],color='red',fontsize=35,fontname='smiley_sans')
        restartbutton.draw()
        screen.draw.text('重开一局',[265,210],color='black',fontsize=40,fontname='smiley_sans')
        exitbutton.draw()
        screen.draw.text('离开游戏',[505,210],color='black',fontsize=40,fontname='smiley_sans')
    elif games==0:
        bg.draw()
        screen.draw.text('坤 坤 跳 跳 乐',[260,50],color='green',fontsize=90,fontname='smiley_sans')
        screen.draw.text('版本:'+VERSION,[425,145],color='green',fontsize=30,fontname='smiley_sans')
        startbutton.draw()
        settingsbutton.draw()
        screen.draw.text('开始游戏',[265,200],color='black',fontsize=40,fontname='smiley_sans')
        screen.draw.text('游戏设置',[505,200],color='black',fontsize=40,fontname='smiley_sans')
        screen.draw.text('按下"空格"键跳跃，按下"s"或"↓"键下蹲，按"a"或"←"键左移，按"d"或"→"键右移',[165,260],color='green',fontsize=20,fontname='smiley_sans')
    elif games==3:
        bg.draw()
        screen.draw.text('游戏设置',[400,40],color='green',fontsize=40,fontname='smiley_sans')
        musicbutton.draw()
        debugbutton.draw()
        exitsettingsbutton.draw()
        screen.draw.text('↑设置背景音乐↑',[270,185],color='green',fontsize=25,fontname='smiley_sans')
        screen.draw.text('↑调试开关↑',[540,185],color='green',fontsize=25,fontname='smiley_sans')
        if musicbg=='huanzhou_dj':
            screen.draw.text('幻昼DJ版',[285,125],color='black',fontsize=40,fontname='smiley_sans')
        else:
            screen.draw.text(musicbg,[285,125],color='black',fontsize=40,fontname='smiley_sans')
        if debug==1:
            screen.draw.text('打开',[565,125],color='black',fontsize=40,fontname='smiley_sans')
        else:
            screen.draw.text('关掉',[565,125],color='black',fontsize=40,fontname='smiley_sans')
        screen.draw.text('退出设置',[405,225],color='black',fontsize=40,fontname='smiley_sans')
    elif games==4:
        bg.draw()
        easyButton.draw()
        midButton.draw()
        hardButton.draw()
        veryHardButton.draw()
        screen.draw.text('狗都会玩',[190,55],color='blue',fontsize=35,fontname='smiley_sans')
        screen.draw.text('地球人该玩',[580,55],color='green',fontsize=35,fontname='smiley_sans')
        screen.draw.text('有亿点难',[190,175],color='orange',fontsize=35,fontname='smiley_sans')
        screen.draw.text(':（',[620,175],color='red',fontsize=35,fontname='smiley_sans')
        screen.draw.text('选择模式',[380,110],color='black',fontsize=45,fontname='smiley_sans')

    if debug==1:
        debugInfo='games='+str(games)+'  '+\
        'jump='+str(jump)+'  '+\
        'score='+str(score)+'  '+\
        'basks='+str(basks)+'  '+\
        'squat='+str(squat)+'  '+\
        'maxscores='+str(maxscores)+' '+\
        'invincible='+str(invincible)+' '+\
        'kun.image='+kun.image+' '+\
        'hp='+str(hp)+' '+\
        'oilCakeS='+str(oilCakeS)+' '
        screen.draw.text(debugInfo,[5,265],color='blue',fontsize=20,fontname='smiley_sans')


def on_key_down(): 
    global jump,games
    if keyboard.K_SPACE and games==1 and jump==0 and squat==0 and invincible==0:
        jump=1
        sounds.jump.play()

def update():
    global games,jump,score,basks,debug,squat,settingsfile,basketballY,invincible,oilCakeS,hp,GAMEINFO
    if games==1:        
        road1.x-=GAMEINFO['speed']
        road2.x-=GAMEINFO['speed']
        cloud1.x-=1.5
        cloud2.x-=1
        cloud3.x-=0.5
        if basks==0:
            kun.x=85
            basketry2.x-=GAMEINFO['speed']
            if score!=(score//GAMEINFO['loop']+1)*GAMEINFO['loop']-1 or score==0:
                basketry1.x-=GAMEINFO['speed']

        if (keyboard.DOWN or keyboard.S) and basks==1 and jump==0 and invincible==0:
            kun.top=225
            kun.image='kunkun_squat'
            squat=1

        elif jump==0:
            kun.y=225
            kun.image='kunkun'
            squat=0

        if percent(GAMEINFO['oilCakeChance']) and oilCakeS==False:
            oilCakeS=True
        
        if oilCakeS:
            oilCake.x-=GAMEINFO['speed']
            if oilCake.left < -5:
                oilCake.x=1050
                oilCakeS=False
        
        if kun.colliderect(oilCake):
            if hp<GAMEINFO['hp']:
                hp+=1
            oilCake.x=1050
            oilCakeS=False

        if (keyboard.LEFT or keyboard.A) and basks==2 and kun.x > 85 and invincible==0:
            kun.x-=5
        if (keyboard.RIGHT or keyboard.D) and basks==2 and kun.x < 890 and invincible==0:
            kun.x+=5
        if invincible!=0:
            jump=0
            kun.image='kunkun_invi'
        if road1.x<-475:
            road1.x=road2.x+950
        if road2.x<-475:
            road2.x=road1.x+950 
        if basketry2.right<-5:
            basketry2.x=basketry1.x+GAMEINFO['interval']
            score+=1
            if percent(20):
                basketry2.image='2basketry'
            else:
                basketry2.image='basketry'
        if basketry1.right<-5:
            if score!=(score//GAMEINFO['loop']+1)*GAMEINFO['loop']-1 or score==0:
                basketry1.x=basketry2.x+GAMEINFO['interval']
            score+=1
            if percent(20):
                basketry1.image='2basketry'
            else:
                basketry1.image='basketry'
        if basketball1.right<-5:
            if percent(GAMEINFO['inviChance']):
                basketball1.pos=[basketball2.x+GAMEINFO['interval'],basketballY[2]]
            else:
                basketball1.pos=[basketball2.x+GAMEINFO['interval'],basketballY[random.randint(0,1)]]
            score+=1
        if basketball2.right<-5:
            if percent(GAMEINFO['inviChance']):
                basketball2.pos=[basketball1.x+GAMEINFO['interval'],basketballY[2]]
            else:
                basketball2.pos=[basketball1.x+GAMEINFO['interval'],basketballY[random.randint(0,2)]]
            score+=1
        if jump==1:
                kun.y-=10
                kun.image='kunkun_jump'
                if kun.bottom<=115:
                    jump=2
        elif jump==2:
                kun.y+=10
                kun.image='kunkun'
                if kun.y==225:
                    jump=0
        if kun.colliderect(sun2):
            if invincible!=0:
                sun2.pos=[random.randint(80,910),-10]
                invincible-=1
                score+=1
            else:
                reduceHealth()
        if kun.colliderect(sun1):
            if invincible!=0:
                sun1.pos=[random.randint(80,910),-10]
                invincible-=1
                score+=1
            else:
                reduceHealth()
        if kun.colliderect(basketry2):
            if invincible!=0:
                if percent(20):
                    basketry2.image='2basketry'
                else:
                    basketry2.image='basketry'
                basketry2.x=basketry1.x+GAMEINFO['interval']
                invincible-=1
                score+=1
            else:
                reduceHealth()
        if kun.colliderect(basketry1):
            if invincible!=0:
                if percent(20):
                    basketry1.image='2basketry'
                else:
                    basketry1.image='basketry'
                if score!=(score//GAMEINFO['loop']+1)*GAMEINFO['loop']-1 or score==0:
                    basketry1.x=basketry2.x+GAMEINFO['interval']
                else:
                    basketry1.x=-5
                invincible-=1
                score+=1
            else:
                reduceHealth()
        if basketball1.colliderect(kun):
            if basketball1.y==basketballY[2] and invincible==0:
                invincible=5              
            if invincible!=0:
                if percent(GAMEINFO['inviChance']):
                    basketball1.pos=[basketball2.x+GAMEINFO['interval'],basketballY[2]]
                else:
                    basketball1.pos=[basketball2.x+GAMEINFO['interval'],basketballY[random.randint(0,1)]]
                invincible-=1
                score+=1
            else:
                reduceHealth()
        if basketball2.colliderect(kun):
            if basketball2.y==basketballY[2] and invincible==0:
                invincible=5              
            if invincible!=0:
                if percent(GAMEINFO['inviChance']):
                    basketball2.pos=[basketball1.x+GAMEINFO['interval'],basketballY[2]]
                else:
                    basketball2.pos=[basketball1.x+GAMEINFO['interval'],basketballY[random.randint(0,1)]]
                invincible-=1
                score+=1
            else:
                reduceHealth()
        if basks==1:
            basketball2.x-=GAMEINFO['speed']
            if score!=(score//GAMEINFO['loop']+1)*GAMEINFO['loop']-1:
                basketball1.x-=GAMEINFO['speed']
        if basks==2:
            sun1.y+=5
            sun2.y+=5
        else:
            sun1.x=-50
            sun2.x=-50
        if sun1.y>HEIGHT:
            sun1.pos=[random.randint(80,910),-10]
        if sun2.y>HEIGHT:
            if invincible!=0:
                invincible-=1
            sun2.pos=[random.randint(80,910),-10]
            score+=1
        for c in clouds:
            if c.x<-55:
                if percent(20):
                    c.image='cloud_face'
                else:
                    c.image='cloud'
                c.x,c.y=1000,random.randint(30,130)
        basks=(score//GAMEINFO['loop'])%3
    elif games==2:
        music.stop()

def on_mouse_down(pos):
    global games,score,settingsfile,musicbg,debug,maxscores
    if debug==1:
        print(pos)

    if games==2:
        if restartbutton.collidepoint(pos):
            music.play(musicbg)
            games=4
        elif exitbutton.collidepoint(pos):
            exit()
    elif games==0:
        if startbutton.collidepoint(pos):
            games=4
        if settingsbutton.collidepoint(pos):
            games=3
    elif games==3:
        if musicbutton.collidepoint(pos):
            if musicbg=='kunmusic':
                musicbg='fuckykun'
            elif musicbg=='fuckykun':
                musicbg='huanzhou_dj'
            elif musicbg=='huanzhou_dj':
                musicbg='kunmusic'
        if debugbutton.collidepoint(pos):
            if debug==0:
                debug=1
                print('============调试已打开============')
            elif debug==1:
                debug=0
                print('============调试已关闭============')
        if exitsettingsbutton.collidepoint(pos):
            settingsfile=open('SETTINGS','w',encoding='utf-8')
            settingsfile.write(musicbg+'\n'+str(debug)+'\n'+str(maxscores))
            settingsfile.close()
            games=0
            music.stop()
            music.play(musicbg)
    elif games==4:
        if easyButton.collidepoint(pos):
            init('esay')
        if hardButton.collidepoint(pos):
            init('hard')
        if midButton.collidepoint(pos):
            init('mid')
        if veryHardButton.collidepoint(pos):
            init('veryHard')

music.play(musicbg)
pgzrun.go()