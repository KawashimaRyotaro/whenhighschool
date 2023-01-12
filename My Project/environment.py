import math
import random as rand
import pygame
import copy

vect = pygame.math.Vector2



class environment:
    def __init__(self, Static_friction_coefficient = 0.9, friction_coefficient = 0.5, damping_coefficient = 0.1, gravity = 9800, phase = 0):
        self.stFC = Static_friction_coefficient
        self.FC   = friction_coefficient
        self.DC   = damping_coefficient
        self.gravConst = gravity
        self.gravity = vect(self.gravConst*math.sin(math.radians(phase)), self.gravConst*math.cos(math.radians(phase)))



class groundPoint:
    def __init__(self, pos, uniq=0):
        self.pos = pos
        self.initPos = vect([0, 0])
        self.posVert = vect([0, 0])
        self.initAngle = 0
        self.prePos = copy.copy(pos)
        self.init = True
        self.uniq = uniq



class Stage:
    def __init__(self, screen, seed=[0, 0], seed_param=[0, 0]):
        self.seed = seed
        self.seedParam = seed_param
        self.ground = [[0, 0]]
        self.progress = 0
        self.viomeNum = len(seed)
        self.screen = screen
        
        self.groundPoints = []
        
    def mkAllStage(self):
        for i in range(self.viomeNum):
            self.mkStage(self.seed[i], self.seedParam[i])
            print(len(self.ground))
    
    def plains(self, param):
        interval = 10
        length = 2400
        for j, i in enumerate(range(self.progress+interval, self.progress+length, interval)):
            point = [i, self.ground[j][1]+float(rand.randint(-10, 10)/5)]
            self.ground.append(point)
            self.groundPoints.append(groundPoint(vect(point)+vect((0, 500))))
        self.progress += length
            
    def mkStage(self, seed, seed_param):
        if seed==0:
            self.plains(seed_param)
    
    def dispStage(self, pos):
        for i in range(len(self.ground)-1):
            if not self.groundPoints[i].uniq == 0:
                pygame.draw.line(self.screen, (255, 0, 0), (150+self.ground[i][0]-pos[0], 500+self.ground[i][1]), (150+self.ground[i+1][0]-pos[0], 500+self.ground[i+1][1]), 5)
            else:
                pygame.draw.line(self.screen, (255, 255, 255), (150+self.ground[i][0]-pos[0], 500+self.ground[i][1]), (150+self.ground[i+1][0]-pos[0], 500+self.ground[i+1][1]), 5)