extends Node

# Guarda el nombre del punto de aparición destino
var punto_aparicion: String = ""

# En global.gd:
var pistas_descubiertas: Array[String] = []

func registrar_pista(id_pista: String) -> void:
	if not pistas_descubiertas.has(id_pista):
		pistas_descubiertas.append(id_pista)
		print("Pista guardada: ", id_pista, " | Total: ", pistas_descubiertas.size(), "/3")
