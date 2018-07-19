import numpy as np
import random as random


class Colony():
	def __init__(self,count, length):
		self.count = count
		self.length = length
		self.ants_pos = []
		for i in range(self.count):
			self.ants_pos.append([round(random.uniform(1,self.length), 2),random.randint(0,1),"Alive"])
		self.ants_pos.sort(key=lambda x:x[0])
		self.state = [v[2] for v in self.ants_pos]
		self.isAlive = True
		self.livingAnts = [v for v in self.ants_pos if v[2]=="Alive"]


	## Moving the colony
	def moveAnt(self,index,dx):
		## Update current position (temporarily)
		## Currdist accounts if left or right
		if self.ants_pos[index][2]: ## If only alive
			## Check if ant is in the border line
			if index == 0: ## Right most ant
				if self.ants_pos[index][1] == 0: ## If left
					self.ants_pos[index][0]-= dx
				else:
					self.ants_pos[index][0]+=dx

			elif index==self.count-1: ## Leftmost ant
				if self.ants_pos[index][1] == 0: ## If left
					self.ants_pos[index][0]-= dx
				else:
					self.ants_pos[index][0]+=dx

			else: ## In between
				if self.ants_pos[index][1]==0 and self.ants_pos[index-1][0]!=0 and self.ants_pos[index-1][2]=="Alive": ## Init left, If -><- collide
					if abs((self.ants_pos[index-1][0]+dx)-(self.ants_pos[index][0]+dx)) > abs(dx):
						self.ants_pos[index][0]-= dx
					else:
						self.ants_pos[index][1]+=1 ## Change direction
						self.ants_pos[index][0]+=dx

				elif self.ants_pos[index][1]!=0 and self.ants_pos[index+1][0]==0 and self.ants_pos[index+1][2]=="Alive": ## Init right, If collide
					if abs((self.ants_pos[index+1][0]+dx)-(self.ants_pos[index][0]+dx)) > abs(dx):
						self.ants_pos[index][0]+=dx
					else:	
						self.ants_pos[index][1]-=1 ## Change direction
						self.ants_pos[index][0]-=dx

				else:
					if self.ants_pos[index][1] == 0: ## If left
						self.ants_pos[index][0]-= dx
					else:
						self.ants_pos[index][0]+=dx


			## If they are at the end of the stick, isAlive = False
			if self.ants_pos[index][0]<=0 or self.ants_pos[index][0]>=self.length:
				self.ants_pos[index][2] = "Dead"

			self.ants_pos[index][0] = round(self.ants_pos[index][0],2)
			
	def move(self,dx):
		for ant in range(self.count):
			self.moveAnt(ant, dx)
			## Update status of the colony

		## Check if colony is dead or alive
		self.state = [v[2] for v in self.ants_pos]
		if "Alive" in self.state:
			self.isAlive = True
		else:
			self.isAlive = False

		living = []
		for i in self.ants_pos:
			if i[2]=="Dead":
				living.append(["==DEAD=="])
			else:
				living.append([i[0],i[1]])
		self.livingAnts = living

	
def main():
	SEED = 50014000
	random.seed(SEED)

	COUNT = 100
	LENGTH = 500  ##in cm
	colony = Colony(COUNT,LENGTH)
	print("Start  0.0  seconds: ",colony.ants_pos)

	SPEED = 1.67 ## cm per sec
	dt = 1.0 ## seconds
	dx = SPEED*dt
	timer = 0

	while(colony.isAlive):
		timer+=dt
		colony.move(dx)
		print("\nUpdating ",timer," secs... Dead: ",colony.state.count("Dead")," Alive: ", colony.state.count("Alive"))
	print("++++++++++++++++++++++++++++++++++++++++++++++++")
	print("After ",timer, " seconds, all ants fell from the stick.")





if __name__ == "__main__":
	main()
	print("done.")