class Humanoide {
	var property estaVivo = true
	var chispaVital = 20
	
	method poderDeAtaque() = self.suerte()
	method poderDeDefensa() = self.poderDeAtaque() * 1.1
	method resistencia()
	method suerte() = -10.randomUpTo(11).truncate(0)
	
	method atacarA(unPersonaje) {
		if(estaVivo && unPersonaje.estaVivo()) 
			self.producirAtaque(unPersonaje)
			chispaVital = 0.max(chispaVital-1)
	}
	method producirAtaque(victima) {
		if(self.mayorPoderQue(victima)) 
			victima.reducirEnergia(self.difenciaDePoderes(victima))
		else self.reducirEnergia(self.difenciaDePoderes(victima))
	}
	method mayorPoderQue(unPersonaje) = self.poderDeAtaque() > unPersonaje.poderDeDefensa()
	method difenciaDePoderes(unPersonaje) = (self.poderDeAtaque() - unPersonaje.poderDeDefensa()).abs()
	method reducirEnergia(unValor)
}

class Humano inherits Humanoide{
	var edad
	var energiaVital = chispaVital + 80.randomUpTo(100).truncate(0)
	var masaMuscular = 30.randomUpTo(71).truncate(0)
	
	method desarrollarMusculatura() {
		if(energiaVital>80) {
			masaMuscular = 60.min(masaMuscular+2)
			energiaVital--
		}
	}
	method energiaVital() = energiaVital
	method masaMuscular() = masaMuscular
	
	override method resistencia() { return
		if(edad<4) energiaVital * 0.2
		else if(edad<12) energiaVital * 0.5
		else if(edad<15) energiaVital * 0.6
		else if(edad<17) energiaVital * 0.8
		else if(edad>70) energiaVital * 0.7
		else energiaVital
	}
	override method poderDeAtaque() = super() + masaMuscular + self.resistencia()
	override method reducirEnergia(unValor) {
		energiaVital = 0.max(energiaVital-unValor)
		if(energiaVital==0) estaVivo = false
	}
}

class Elfo inherits Humanoide {
	var energiaVital = chispaVital + 90.randomUpTo(110).truncate(0)
	var masaMuscular = 20.randomUpTo(51).truncate(0)
	var nivelDeMagia = 1.randomUpTo(8).truncate(0)
	
	method desarrollarPoderMagico() {
		if(energiaVital>60) {
			nivelDeMagia = 40.min(nivelDeMagia+3)
			energiaVital--
		}
	}
	method masaMuscular() = masaMuscular
	override method resistencia() = energiaVital
	
	override method poderDeAtaque() = super() + masaMuscular + self.resistencia()
	override method poderDeDefensa() = super() + nivelDeMagia
	override method reducirEnergia(unValor) {
		energiaVital = 0.max(energiaVital-unValor)
		if(energiaVital==0) estaVivo = false
	}
	
}

class Enano inherits Humanoide {
	var edad
	var energiaVital = chispaVital + 75.randomUpTo(100).truncate(0)
	var masaMuscular = 35.randomUpTo(45).truncate(0)
	var nivelDeIra = 1.randomUpTo(1.3).truncate(2)
	
	method masaMuscular() = masaMuscular
	method practicarRitoSiginTarag() {nivelDeIra = 2.min(nivelDeIra + 0.1)}
	
	override method poderDeAtaque() = super() + masaMuscular * 0.5 + self.resistencia()
	override method poderDeDefensa() = super() * nivelDeIra	
	override method reducirEnergia(unValor) {
		energiaVital = 0.max(energiaVital-unValor)
		if(energiaVital==0) estaVivo = false
	}
	override method resistencia() = energiaVital * (nivelDeIra + 18.max(350.min(edad))/50 )
	
}

class Orco inherits Elfo {
	
	override method desarrollarPoderMagico() {if(energiaVital>60) energiaVital--}
	override method poderDeDefensa() = self.poderDeAtaque()
	
}

class Istar inherits Humanoide {
	var property color
	var energiaVital = chispaVital + 80.randomUpTo(120).truncate(0)
	var destrezaConLaEspada = 10.randomUpTo(20).truncate(0)
	var masaMuscular = 30.randomUpTo(71).truncate(0)
	
	method evolucionar() {color = color.proximoColor()}
	method masaMuscular() = masaMuscular
	method poderMagico() = color.poderMagico()
	
	override method poderDeAtaque() = 
		super() + destrezaConLaEspada + self.resistencia() + self.poderMagico()
	override method reducirEnergia(unValor) {
		energiaVital = 0.max(energiaVital-unValor)
		if(energiaVital==0) estaVivo = false
	}
	override method resistencia() = energiaVital
}

object sauron inherits Humanoide {
	var energiaVital = 1300
	
	method chispaVital() = 0
	method masaMuscular() = 0
	method raza() = self
	
	override method poderDeAtaque() = super() + self.resistencia()
	override method reducirEnergia(unValor) {
		energiaVital = 0.max(energiaVital-unValor)
		if(energiaVital==0) estaVivo = false
	}
	override method resistencia() = energiaVital
}

class Hobbit inherits Humanoide {
	const property masaMuscular = 20.randomUpTo(30).truncate(0)
	var edad
	var energiaVital = chispaVital + 50.randomUpTo(90).truncate(0)
	var nivelDeAgilidad = (1.1).randomUpTo(1.8).truncate(2)
	
	method chispaVital() = 0
	method energiaVital() = energiaVital
	method entrenarAgilidad() {nivelDeAgilidad = 2.min(nivelDeAgilidad + 0.1)}
	method masaMuscular() = masaMuscular
	method raza() = hobbit
	
	override method poderDeAtaque() = super() + masaMuscular/2 + self.resistencia()
	override method poderDeDefensa() = super() * nivelDeAgilidad
	override method reducirEnergia(valorARestar) {
		energiaVital = 0.max(energiaVital-valorARestar)
		if(energiaVital == 0) estaVivo = false
	}
	override method resistencia() = energiaVital * (nivelDeAgilidad + 20.max(200.min(edad))/50) 
}

object humano {method raza() = self}
object elfo {method raza() = self}
object enano {method raza() = self}
object orco {method raza() = self}
object istar {method raza() = self}
object hobbit {method raza() = self}

object blanco {method poderMagico() = 60 method proximoColor()=self}
object gris {method poderMagico() = 40 method proximoColor()=blanco}
object azul {method poderMagico() = 30 method proximoColor()=gris}
object pardo {method poderMagico() = 20 method proximoColor()=azul}