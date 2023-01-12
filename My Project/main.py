import pygame
import macine as mac
import environment as env
import UI
import copy
import math

vect = pygame.math.Vector2

class main:
    def __init__(self):
        pygame.init()
        self.time = pygame.time
        self.clock = self.time.Clock()
               
        self.width = 1200
        self.height = 800
        self.screen = pygame.display.set_mode((self.width, self.height))
        self.env = env.environment()
        self.myCan = mac.CanSat()
        self.UI = UI
        self.stage = env.Stage(self.screen)
        self.stage.mkAllStage()
        self.pos = vect(0, 0)
        self.vel = vect(0, 0)
        self.force = vect(0, 0)
        
        self.paramsString = ["Weight", "Tier Radius", "Tier Elastisity", "Tier Viscousity", "Gravity", "Air Resistance"]
        self.params = [self.myCan.M, self.myCan.TR, self.myCan.Elast, self.myCan.Damp, self.env.gravConst, self.env.DC]
        self.paramsRe = copy.copy(self.params)
        self.txBoxes = [self.UI.textBox([250, 100+45*i], [140, 40]) for i in range(len(self.params))]
        self.assumButton = [self.UI.Button([500, 100+45*i], [40, 40]) for i in range(len(self.params))]
        self.proceedButton = self.UI.Button([800, 700], [40, 40], text="Proceed ->")
        self.resetButton = self.UI.Button([500, 700], [200, 40], text="Reset <-")
        self.resetSimButton = self.UI.Button([500, 700], [200, 40], text="Reset <-")

        
        self.titleFont = pygame.font.Font(None, 100)
        self.subFont = pygame.font.Font(None, 50)
        self.expFont = pygame.font.Font(None, 25)
        self.commentFont = pygame.font.Font(None, 25)
        
        self.phase = 0      #0:start, 1:inputParam, 2:simulator, 3:result
        self.should_quit = False
        self.start = False
        self.inputParam = False
        
        self.comment=""
        self.nt = pygame.time.get_ticks()
        self.pt = pygame.time.get_ticks()
        self.dt = 0
        self.activegPs = []
    
#---------------------------------------------------------------------------------------------------#
#Sene
    def commentBox(self):
        comment = self.commentFont.render("Comment : " + self.comment, True, (200, 200, 200))
        self.screen.blit(comment, (5, 5))


    def initialScene(self):
        self.screen.fill((0,0,0))                                    # 画面を黒色に塗りつぶし
        title = self.titleFont.render("CanSat Simulator", True, (255,255,255))   # 描画する文字列の設定
        sub = self.subFont.render("--- Press \"Space\" to Start! ---", True, (255,255,255))   # 描画する文字列の設定
        title_rect = title.get_rect(center=(self.width//2, self.height//2-50))
        sub_rect = sub.get_rect(center=(self.width//2, self.height//2+100))
        self.screen.blit(title, title_rect)# 文字列の表示位置
        
        if (self.time.get_ticks() % 2000)<1000:
            self.screen.blit(sub, sub_rect)# 文字列の表示位置
        
        self.commentBox()
        
        pygame.display.update()     # 画面を更新
    
    
    def inputScene(self):
        self.screen.fill((0,0,0))
        inpTxt = self.expFont.render("Input parameter", True, (255, 255, 255))
        newParam = self.expFont.render("New Parameter", True, (255, 255, 255))
        nowParam = self.expFont.render("Now Parameter", True, (255, 255, 255))
        self.screen.blit(inpTxt, (250, 75))
        self.screen.blit(newParam, (500, 75))
        self.screen.blit(nowParam, (750, 75))
        for i, (button, box, txt, val) in enumerate(zip(self.assumButton, self.txBoxes, self.paramsString, self.params)):
            box.draw(self.screen)
            button.draw(self.screen)
            paramName = self.expFont.render(txt, True, (255, 255, 255))
            paramVal = self.expFont.render(str(val), True, (255, 255, 255))
            self.screen.blit(paramName, (100, 110+45*i))
            self.screen.blit(paramVal, (750, 110+45*i))
        self.proceedButton.draw(self.screen)
        self.resetButton.draw(self.screen)
        self.myCan.dispCanStat(self.screen, (275, 650), 750)
        
        self.commentBox()
        
        pygame.display.update()     # 画面を更新
    
    
    def simulationScene(self):
        self.screen.fill(pygame.Color("black"))
        self.myCan.dispCanStat(self.screen, (150, 150))
        self.myCan.dispCan(self.screen)
        self.stage.dispStage(self.myCan.pos)
        
        self.resetSimButton.draw(self.screen)
        self.proceedButton.update()
        
        self.commentBox()
        
        pygame.display.update()
        
        
    def gameOverScene(self):
        title = self.titleFont.render("Simulation Is Over...", True, (255,255,255))   # 描画する文字列の設定
        sub = self.subFont.render("--- Press \"Space\" to Restart ---", True, (255,255,255))   # 描画する文字列の設定
        title_rect = title.get_rect(center=(self.width//2, self.height//2-50))
        sub_rect = sub.get_rect(center=(self.width//2, self.height//2+150))
        self.screen.blit(title, title_rect)# 文字列の表示位置
        self.screen.blit(sub, sub_rect)# 文字列の表示位置
            
        self.commentBox()
        pygame.display.update()     # 画面を更新
#--------------------------------------------------------------------------------------------------#

    
#--------------------------------------------------------------------------------------------------#
#events
    def judgeQuit(self):
        for event in self.events:
            if event.type == pygame.QUIT:
                self.should_quit = True
            elif event.type == pygame.KEYDOWN:
                if event.key == pygame.K_ESCAPE:
                    self.should_quit = True


    def startEve(self):
        for event in self.events:
            if event.type == pygame.KEYDOWN:
                if event.key == pygame.K_SPACE:
                    self.phase += 1
                    self.comment = "Imput value into textbox and push the button which is right hand of that."

    def inputEve(self):
        for event in self.events:
            for i, (box, button) in enumerate(zip(self.txBoxes, self.assumButton)):
                r = box.handle_event(event)
                if not r=="":
                    button.text = copy.copy(r)
                box.update()
                button.handle_event(event)
                button.update()
                if button.active:
                    try:
                        self.params[i] = float(r)
                        self.comment = "Value changed successfully!"
                    except:
                        self.comment = "Imput valid value! (half-width alphanumeric characters)"
                    
            self.proceedButton.handle_event(event)
            if self.proceedButton.active:
                self.phase += 1
                self.comment = "Started successfully!"
                self.nt = pygame.time.get_ticks()
                self.pt = pygame.time.get_ticks()
                self.dt = self.nt-self.pt
                self.refresh()
                self.myCan.omega = 0.0
                self.myCan.angle = 0.0
                self.myCan.pos = vect(150, 300)
                self.myCan.vel = vect(0, 0)
                self.proceedButton.active = False
                print(self.myCan.vel, self.myCan.pos, self.myCan.angle, self.myCan.omega)
            else:
                self.proceedButton.update()
                
            self.resetButton.handle_event(event)
            if self.resetButton.active:
                self.comment = "All value was resetted."
                for i, p in enumerate(self.paramsRe):
                    self.params[i] = p
                    self.assumButton[i].text = ""
    
        self.myCan.M = self.params[0]
        self.myCan.TR = self.params[1]
        self.myCan.Elast = self.params[2]
        self.myCan.Damp = self.params[3]
        
    
    def moveStageEve(self):
        flag=0
        self.refresh()

        pressed_key = pygame.key.get_pressed()
        if pressed_key[pygame.K_LEFT]:
            self.myCan.totalForce = vect([-1000, 0])
        elif pressed_key[pygame.K_RIGHT]:
            self.myCan.totalForce = vect([1000, 0])
        else:
            self.myCan.totalForce = vect([0, 0])
        
        # print(self.myCan.totalForce)

        self.nt = pygame.time.get_ticks()
        self.dt = float((self.nt - self.pt)/1000)
        if self.dt==0 or self.dt>=0.01:
            self.dt = 0.005
        self.gravityForce()
        self.viscousDampingForce()
        self.groundInteraction()
        self.integrateSymplectic()
        self.pt = copy.copy(self.nt)
        # print(self.myCan.totalForce)
        
        # print(self.myCan.pos[0])
        if self.myCan.pos[0]<0 or self.myCan.pos[0]>self.stage.progress:
            self.phase += 1
        
        for event in self.events:
            self.resetSimButton.handle_event(event)
            if self.resetSimButton.active:
                self.phase = 1
                self.comment = "Imput value into textbox and push the button which is right hand of that."
                self.resetSimButton.active = False
        
        print(self.myCan.vel, self.myCan.pos, self.myCan.angle, self.myCan.omega, self.myCan.totalForce, self.myCan.torque)
        
        
    def gameOverEve(self):
        for event in self.events:
            if event.type == pygame.KEYDOWN:
                if event.key == pygame.K_SPACE:
                    self.phase = 1
                    self.comment = "Imput value into textbox and push the button which is right hand of that."
#--------------------------------------------------------------------------------------------------#
        
        
#--------------------------------------------------------------------------------------------------#
#update status
    def gravityForce(self):
        self.myCan.totalForce += self.myCan.M * self.env.gravity


    def viscousDampingForce(self):
        self.myCan.totalForce += -self.env.DC * self.vel


    def groundInteraction(self):
        self.activegPs = []
        self.nallowDown()
        # print("div")
        for i, point in enumerate(self.activegPs):
            convPoint = point.pos - self.myCan.pos
            angle = self.myCan.angle
            norm = convPoint.length()
            if norm <= self.myCan.TR*1000:
                if point.init:
                    point.initPos = convPoint
                    point.prePos = convPoint
                    point.initAngle = self.myCan.angle
                    point.init = False
                
                Fe = self.myCan.Elast * (self.rot(point.initPos, angle-point.initAngle)-convPoint)
                Fd = self.myCan.Damp * (self.rot(point.prePos, self.myCan.omega * self.dt) - convPoint)/self.dt
                # print(self.rot(point.prePos, self.myCan.omega * self.dt) , convPoint)
                # print((self.rot(point.initPos, angle-point.initAngle)-convPoint), (self.rot(point.prePos, self.myCan.omega * self.dt) - convPoint))
                # print(Fe, Fd)
                removeForce = Fe + Fd
                self.myCan.totalForce[0] -= removeForce[0]
                self.myCan.totalForce[1] -= removeForce[1]

                point.posVert = self.rot(convPoint, 90)/norm
                addTorque = self.innerProduct(point.posVert, removeForce)
                self.myCan.torque -= addTorque
                # print(self.myCan.totalForce, removeForce, addTorque)
                point.prePos = copy.copy(convPoint)
            else:
                if not point.init:
                    point.initPos = convPoint
                    point.initAngle = self.myCan.angle
                    point.init = False
                    Fe = self.myCan.Elast * (self.rot(point.initPos, angle-point.initAngle)-convPoint)
                    Fd = self.myCan.Damp * (self.rot(point.prePos, self.myCan.omega * self.dt) - convPoint)/self.dt
                    # print((self.rot(point.initPos, angle-point.initAngle)-convPoint), (self.rot(point.prePos, self.myCan.omega * self.dt) - convPoint))
                    # print(Fe, Fd)
                    removeForce = Fe + Fd
                    self.myCan.totalForce -= removeForce

                    point.posVert = self.rot(convPoint, 90)/norm
                    addTorque = self.innerProduct(point.posVert, removeForce)
                    self.myCan.torque += addTorque*norm
                point.init = True
                point.prePos = vect(0, 0)
                point.initPos = vect(0, 0)
                point.initAngle = 0



    def rot(self, pos, angle):
        return vect([pos[0]*math.cos(math.radians(angle)) + pos[1]*math.sin(math.radians(angle)), -pos[0]*math.sin(math.radians(angle)) + pos[1]*math.cos(math.radians(angle))])


    def innerProduct(self, v1, v2):
        return v1[0]*v2[0]+v1[1]*v2[1]


    def integrateSymplectic(self):
        # print(self.myCan.totalForce, self.myCan.vel, self.myCan.pos, self.dt)
        self.myCan.vel = self.myCan.vel + self.myCan.totalForce / self.myCan.M * self.dt
        self.myCan.pos = self.myCan.pos + self.myCan.vel * self.dt
        self.myCan.omega = self.myCan.omega + self.myCan.torque / (self.myCan.M*(self.myCan.TR*1000)**2)
        self.myCan.angle = self.myCan.angle + self.myCan.omega * self.dt
    
    
    def refresh(self):
        self.myCan.totalForce = vect([0, 0])
        self.myCan.torque = 0.0
    
    
    def nallowDown(self):
        for i, point in enumerate(self.stage.groundPoints):
            if (point.pos[0] < self.myCan.pos[0]+self.myCan.TR*1000) and (point.pos[0]>self.myCan.pos[0]-self.myCan.TR*1000):
                self.activegPs.append(point)
                point.uniq = 1
            else:
                point.uniq = 0
                # print(i)
#--------------------------------------------------------------------------------------------------#        
        
        
#--------------------------------------------------------------------------------------------------#
#Master Functions
    def Event(self):
        self.events = pygame.event.get()
        self.judgeQuit()
        if self.phase == 0:
            self.startEve()
        elif self.phase == 1:
            self.inputEve()
        elif self.phase == 2:
            self.moveStageEve()
        elif self.phase == 3:
            self.gameOverEve()
    
    
    def drawScene(self):
        if self.phase == 0:
            self.initialScene()
        elif self.phase == 1:
            self.inputScene()
        elif self.phase == 2:
            self.simulationScene()
        elif self.phase == 3:
            self.gameOverScene()
    
    
    def run(self):
        while not self.should_quit:
            self.Event()
            self.drawScene()
#--------------------------------------------------------------------------------------------------#
            
        
if __name__ == "__main__":
    main().run()