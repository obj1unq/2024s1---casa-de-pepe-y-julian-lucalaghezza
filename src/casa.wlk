object casaDePepeYJulian {

	var property viveres = 50
	var reparaciones = 0
	var cuenta
	var estrategia

	method tieneViveresSuficientes() {
		return viveres > 40
	}

	method requiereReparaciones() {
		return reparaciones > 0
	}

	method estaEnOrden() {
		return !self.requiereReparaciones() && self.tieneViveresSuficientes()
	}

	method aumentarReparaciones(monto) {
		reparaciones += monto
	}

	method agregarViveres(porcentaje) {
		viveres += porcentaje
	}

	method viveres() {
		return viveres
	}

	method reparaciones() {
		return reparaciones
	}

	method cuenta(_cuenta) {
		cuenta = _cuenta
	}

	method gasto(importe) {
		cuenta.extraer(importe)
	}

	method estrategia(_estrategia) {
		estrategia = _estrategia
	}
	
	method saldo(){
		return cuenta.saldo()
	}
	
	method reparar(){
		self.gasto(reparaciones)
		reparaciones = 0
	}

	method mantenimiento() {
		estrategia.mantener(self)
	}

}

/// CUENTAS BANCARIAS
object cuentaCorriente {

	var saldo = 0

	method depositar(monto) {
		saldo += monto
	}

	method extraer(monto) {
		saldo -= monto
	}

	method saldo() {
		return saldo
	}

}

object cuentaConGastos {

	var saldo = 0

	method depositar(monto) {
		saldo += monto
	}

	method extraer(monto) {
		saldo -= monto
	}

	method saldo() {
		return saldo.max(0)
	}

	method costoPorOperacion(costo) {
		saldo -= costo
	}

	method costoPorOperacion() {
		return saldo.min(0).abs()
	}

}

object cuentaCombinada {

	var property cuentaPrimaria = null
	var property cuentaSecundaria = null

	method depositar(monto) {
		cuentaPrimaria.depositar(monto)
	}

	method extraer(monto) {
		if (cuentaPrimaria.saldo() >= monto) {
			cuentaPrimaria.extraer(monto)
		} else {
			cuentaSecundaria.extraer(monto)
		}
	}

	method saldo() {
		return cuentaPrimaria.saldo() + cuentaSecundaria.saldo()
	}

}

// ESTRATEGIAS DE AHORRO
object minimoEIndispensable {

	var property calidad = 1

	method viveresNecesarios(casa) {
		return 40 - casa.viveres()
	}

	method mantener(casa) {
		if (!casa.tieneViveresSuficientes()) {
			casa.gasto(self.viveresNecesarios(casa) * calidad)
			casa.agregarViveres(self.viveresNecesarios(casa))
		}
	}

}

object full {

	const calidad = 5

	method viveresNecesarios(casa) {
		return 100 - casa.viveres()
	}
	
	method repararSiAlcanza(casa){
		if (casa.saldo() > (casa.reparaciones() + 1000)){
			casa.reparar()
		}
	}

	method mantener(casa) {
		if (casa.estaEnOrden()) {
			casa.gasto(self.viveresNecesarios(casa) * calidad)
			casa.agregarViveres(self.viveresNecesarios(casa))
		} else {
			casa.gasto(40 * calidad)
			casa.agregarViveres(40)
			self.repararSiAlcanza(casa)
		}		
	}

}

