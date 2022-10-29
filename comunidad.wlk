import razas.*

object comunidadDelAnillo {
	const property razas = #{hobbit,humano,enano,elfo,istar}
	// Lista con orden y con indice.
	const miembros = []
	// Conjunto sin orden y sin indice.
	const miembrosDifuntos = #{}
	
	// Agrega conjunto de miembros.
	method agregarMiembros(unConjunto) {
		if((miembros.size() + unConjunto.size()) > 10 ) 
			self.error("No se puede superar 10 miembros")
		miembros.addAll(unConjunto)
	}
	// Tamaño de la lista de miembros.
	method cantidadMiembros() = miembros.size()
	// Tamaño de la lista de mimebros difuntos.
	method cantidadMiembrosDifuntos() = miembrosDifuntos.size()
	// Si la comunidad está lista. True o False.
	method estaLista() = miembros.size() >= 8 && self.existenTodasLasRazas()
	
	// Si existen todas las razas. True o False.
	method existenTodasLasRazas() = razas.all({r => self.miembrosSiTiene(r)})
	// Si hay determinadas raza en la lista de miembros.
	method miembrosSiTiene(unaRaza) = miembros.any({m => m.raza()== unaRaza})
	// Opción 2.
	method existenTodas2() = razas.difference(miembros.map({m => m.raza()})).isEmpty()
	
	// 
	method retirarMiembrosDifuntos() = miembros.forEach(
		{m => self.trasladarMiembroDifunto(m)}
	)
	// Remueve miembro muerto de miembros y lo agrega a miembros difuntos.
	method trasladarMiembroDifunto(unMiembro) {
		if(not unMiembro.estaVivo()) {
			miembros.remove(unMiembro)
			miembrosDifuntos.add(unMiembro)
		}
	}
	
	// Suma del poder de ataque de todos los miembros.
	method poderDeAtaque() = miembros.sum({ m => m.poderDeAtaque() })
	// Suma del poder de defensa de todos los miembros.
	method poderDeDefensa() = miembros.sum({ m => m.poderDeDefensa() })
	
	// Ataca a un personaje.
	method atacarA(unPersonaje) {
		if(self.estaLista() and unPersonaje.estaVivo()) 
			self.producirAtaque(unPersonaje)
	}
	
	// Produce ataque.
	method producirAtaque(victima) {
		if(self.mayorPoderQue(victima)) 
			victima.reducirEnergia(self.difenciaDePoderes(victima))
		else self.reducirEnergia(self.difenciaDePoderes(victima))
	}
	// True o False.
	method mayorPoderQue(unPersonaje) = self.poderDeAtaque() > unPersonaje.poderDeDefensa()
	// Cálculo. abs() es numero absoluto, sin decimales.
	method difenciaDePoderes(unPersonaje) = (self.poderDeAtaque() - unPersonaje.poderDeDefensa()).abs()
	// Reduce energia en cada miembro.
	method reducirEnergia(unValor) {
		miembros.forEach({ m => m.reducirEnergia(unValor / miembros.size()) })
	}
	
	// Devuelve una lista con los miembros que cumplen condicion.
	method miembrosConPoderDeDefensaMayorAPromedio() = 
		miembros.filter({ m => m.poderDeDefensa() > self.promedioDeDefensa() })
	// Método auxiliar para arriba.
	method promedioDeDefensa() = self.poderDeDefensa() / self.cantidadMiembros()
	
	// True si todos tienen masa muscular mayor a unValor.
	method todosConMasaMuscularMayorA(unValor) = 
		miembros.all({ m => m.masaMuscular() > unValor})
	
	// True si miembros contiene a unMiembro.
	method miembroActivoEnLaComunidad(unMiembro) = miembros.contains(unMiembro)
	
	// True si se cumplen condiciones.
	method vaPerdiendo() = self.cantidadMiembrosDifuntos() > self.cantidadMiembros() and sauron.estaVivo()
	
	// Devuelve objeto con mayor poder de ataque.
	method miembroConMayorPoderDeAtaque() = miembros.max({ m => m.poderDeAtaque()})
	
	// Devuelve el poder de defensa del miembro con mayor PdeD.
	method maximoPoderDeDefensa() = miembros.max({ m => m.poderDeDefensa()}).poderDeDefensa()
	
	// True si alguno de los miembros tiene chispa menor a unValor.
	method algunMiembroConChispaMenorA(unValor) = miembros.any({ m => m.chispaVital() < unValor})
	
	// Devuelve la raza con el maximo de miembros.
	method razaConMasMiembros() = self.razas().max({r => self.cantidadMiembrosDeUnaRaza(r)})
	// Método auxiliar. Lista con las razas de los miembros.
	method razas() = miembros.map({ m => m.raza()})
	// Método auxiliar. Cantidad de miembros que son de unaRaza.
	method cantidadMiembrosDeUnaRaza(unaRaza) = miembros.count({ m => m.raza() == unaRaza})
	
	// True si el poder de ataque de los miembros es creciente.
	// Compara el primero (0) con el segundo (1) y así hasta el final (len() - 1)
	method poderDeAtaqueCreciente() = 
		// Lista auxiliar de índices. (1..self.cantidadMiembros() - 1)
		(1..self.cantidadMiembros() - 1).all({ 
			indice => miembros.get(indice).poderDeAtaque() >= miembros.get(indice - 1).poderDeAtaque()
		})
	
	// Devuelve unaCantidad de los miembros mas poderosos. Toma cantidad de miembros.
	method miembrosMasPoderosos(cantidad) =
		self.miembrosPorOrdenDePoderDeAtaque().take(cantidad)
	// Ordena los miembros segun poder de ataque. De mayor a menor.
	method miembrosPorOrdenDePoderDeAtaque() = miembros.sortedBy({
		x, y => x.poderDeAtaque() > y.poderDeAtaque()
	})
	
}
