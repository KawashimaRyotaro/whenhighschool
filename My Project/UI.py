import pygame
import main
import copy



class Button:
    def __init__(self, pos, size, fontSize=None, font=None, textColor = (0, 0, 0), rectColor = (200, 200, 200), text=''):
        self.rect = pygame.Rect(pos[0], pos[1], size[0], size[1])
        self.tColor = textColor
        self.rActColor = rectColor
        self.rInActColor = (100, 100, 100)
        self.rFloatColor = (150, 150, 150)
        self.color = self.rInActColor
        self.text = text
       
        if fontSize is None:
            self.fontSize = 40
            self.font = pygame.font.Font(font, 40)
        else:
            self.fontSize = fontSize
            self.font = pygame.font.Font(font, fontSize)
            
        self.txt_surface = self.font.render(text, True, self.color)
        self.active = False
        self.float = False
       
       
    def update(self):
        width = max(200, self.txt_surface.get_width()+10)
        self.rect.w = width
       
       
    def draw(self, screen):
        pygame.draw.rect(screen, self.color, self.rect, 0)
        self.txt_surface = self.font.render(self.text, True, self.tColor)
        screen.blit(self.txt_surface, (self.rect.x+5, self.rect.y+5))
        
        
    def handle_event(self, event):
        if event.type == pygame.MOUSEBUTTONUP:
            if self.rect.collidepoint(event.pos):
                self.active = True
            else:
                self.active = False
            self.color = self.rActColor if self.active else self.rInActColor
            
            
        elif event.type == pygame.MOUSEMOTION:
            if self.rect.collidepoint(event.pos):
                self.float = True
            else:
                self.float = False
            self.color = self.rFloatColor if self.float else self.rInActColor
                
                
    def onClick(self):
        r = self.active
        self.active = False
        return r



class textBox:
    def __init__(self, pos, size, fontSize=None, font=None, textColor = (255, 255, 255), rectColor = (255, 255, 255), text=""):
        pygame.init()
        self.rect = pygame.Rect(pos[0], pos[1], size[0], size[1])
        
        self.tColor = textColor
        self.rActColor = rectColor
        self.rInActColor = (100, 100, 100)
        self.rFloatColor = (150, 150, 150)
        self.color = self.rInActColor
        
        self.text = text
        self.active = False
        self.float = False
        self.carsol = 0
        
        self.r = ""
        
        if fontSize is None:
            self.fontSize = 40
            self.font = pygame.font.Font(font, 40)
        else:
            self.fontSize = fontSize
            self.font = pygame.font.Font(font, fontSize)
            
        self.txt_surface = self.font.render(text, True, self.tColor)
        
        
    def handle_event(self, event):
        if event.type == pygame.MOUSEBUTTONDOWN:
            if self.rect.collidepoint(event.pos):
                self.active = not self.active
            else:
                self.active = False
            self.color = self.rActColor if self.active else self.rInActColor
        if event.type == pygame.MOUSEMOTION:
            if self.rect.collidepoint(event.pos):
                self.float = True
            else:
                self.float = False
            self.color = self.rFloatColor if self.float else self.rInActColor
        if event.type == pygame.KEYDOWN:
            if self.active:
                if event.key == pygame.K_RETURN:
                    self.enter()
                elif event.key == pygame.K_DELETE:
                    self.delete()
                elif event.key == pygame.K_BACKSPACE:
                    self.backspace()
                elif event.key == pygame.K_LEFT:
                    self.left()
                elif event.key == pygame.K_RIGHT:
                    self.right()
                else:
                    self.inputChar(event)
                self.txt_surface = self.font.render(self.text[:self.carsol]+"|"+self.text[self.carsol:], True, self.tColor)
        return self.r
    
    
    def enter(self):
        self.r = copy.copy(self.text)
        self.text = ''
        
        
    def delete(self):
        if self.carsol==len(self.text):
            return
        else:
            txtF = self.text[:self.carsol]
            txtB = self.text[self.carsol+1:]
            self.text = txtF+txtB
            return
    
    
    def backspace(self):
        if self.carsol==0:
            return
        else:
            self.carsol -= 1
            txtF = self.text[:self.carsol]
            txtB = self.text[self.carsol+1:]
            self.text = txtF+txtB
            return
        
        
    def left(self):
        if self.carsol==0:
            return
        else:
            self.carsol -= 1
        
        
    def right(self):
        if self.carsol==len(self.text):
            return
        else:
            self.carsol += 1
        
        
    def inputChar(self, event):
        Ftxt = self.text[:self.carsol]+event.unicode
        Btxt = self.text[self.carsol:]
        self.text =Ftxt+Btxt
        self.carsol += 1
    
    
    def update(self):
        width = max(200, self.txt_surface.get_width()+10)
        self.rect.w = width
        
        
    def draw(self, screen):
        screen.blit(self.txt_surface, (self.rect.x+5, self.rect.y+5))
        pygame.draw.rect(screen, self.color, self.rect, 2)