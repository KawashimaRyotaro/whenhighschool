import pygame
import math

vect = pygame.math.Vector2


class Phisics:
    def __init__(self, macine):
        self.mac = macine
        
    


class CanSat:
    def __init__(self, body_mass=0.5, total_length=0.2, body_radius=0.05, body_witdth=0.16, tire_radius=0.07, tire_width=0.075, tire_mass=0.3, stabirizer_mass=0.1, stabilizer_width=0.01, stabilizer_length=0.08):
        self.TL = total_length

        self.BR = body_radius
        self.BW = body_witdth
        self.BM = body_mass
        
        self.TR = tire_radius
        self.TW = tire_width
        self.TM = tire_mass
        
        self.SL = stabilizer_length
        self.SW = stabilizer_width
        self.SM = stabirizer_mass

        self.M  = self.BM + self.TM + self.SM
        
        self.Elast = 2000
        self.Damp = 5
        
        self.pos = vect(150, 300)
        self.vel = vect(0, 0)
        self.totalForce = vect(0, 0)
        self.angle = 0.0
        self.omega = 0.0
        self.torque = 0.0
    
    
    def dispCan(self, screen):
        pygame.draw.circle(screen, (230, 216, 179), (150, self.pos[1]), (self.TR*1000), 0)
        pygame.draw.circle(screen, (100, 100, 100), (150-self.TR*500*math.sin(math.radians(self.angle)), self.pos[1]-self.TR*500*math.cos(math.radians(self.angle))), (self.TR*250), 0)
        pygame.draw.circle(screen, (100, 100, 100), (150+self.TR*500*math.cos(math.radians(self.angle)), self.pos[1]-self.TR*500*math.sin(math.radians(self.angle))), (self.TR*250), 0)
        pygame.draw.circle(screen, (100, 100, 100), (150+self.TR*500*math.sin(math.radians(self.angle)), self.pos[1]+self.TR*500*math.cos(math.radians(self.angle))), (self.TR*250), 0)
        pygame.draw.circle(screen, (100, 100, 100), (150-self.TR*500*math.cos(math.radians(self.angle)), self.pos[1]+self.TR*500*math.sin(math.radians(self.angle))), (self.TR*250), 0)


    
    def dispCanStat(self, screen, pos, mag=500):
        pygame.draw.rect(screen, (192, 153, 51), (pos[0]-int(self.BW*mag/2), pos[1]-int(self.BR*mag), int(self.BW*mag), int(self.BR*mag*2)))
        pygame.draw.rect(screen, (230, 216, 179), (pos[0]-int(self.TL*mag/2), pos[1]-int(self.TR*mag), int(self.TW*mag), int(self.TR*mag*2)))
        pygame.draw.rect(screen, (230, 216, 179), (pos[0]+int((self.TL/2-self.TW)*mag), pos[1]-int(self.TR*mag), int(self.TW*mag), int(self.TR*mag*2)))
        pygame.draw.rect(screen, (170, 0, 0), (pos[0]-int(self.SW*mag/2), pos[1]+int(self.BR*mag), int(self.SW*mag), int((self.SL-self.BR)*mag)))