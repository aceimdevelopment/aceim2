# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# 10.times { Item.create!(name: "Item", description: "I am a description.") }

10.times { Item.create!(name: "Item", description: "I am a description.") }

Language.create([{id: 'ING', name: 'Inglés'}, 
	{id: 'ALE', name: 'Alemán'}, 
	{id: 'FRA', name: 'Francés'}, 
	{id: 'ITA', name: 'Italiano'},
	{id: 'POR', name: 'Portugués'}])


Level.create([
{id: "AC", name: "Advanced Conversation"},
{id: "AD", name: "Advanced"},
{id: "AI", name: "Avanzado I"},
{id: "AII",  name: "Avanzado II"},
{id: "AIII",  name: "Avanzado III"},
{id: "AP", name: "Advanced Plus"},
{id: "BBVA", name: "BBVA"},
{id: "BE", name: "Beginners"},
{id: "BI", name: "Básico I"},
{id: "BII",  name: "Básico II"},
{id: "BIII", name: "Básico III"},
{id: "CA", name: "Conversación Avanzado"},
{id: "CB", name: "Conversación Básico"},
{id: "CC", name: "Club Conversacion"},
{id: "CI", name: "Conversación Intermedio"},
{id: "EL", name: "Elementary"},
{id: "IN", name: "Intermediate"},
{id: "MI", name: "Intermedio I"},
{id: "MII",  name: "Intermedio II"},
{id: "MIII", name: "Intermedio III"},
{id: "NI", name: "Nivelacion"}])

Agreement.create([
{id: "ADM", name: "Convenio Escuela de Administración", value: 0, discount: 100},
{id: "Administra", name: "Escuela de Administración 50%", value: 100000, discount: 50},
{id: "AUT30", name: "Descuento Autorizado por Directiva 30%", value: 140000, discount: 30},
{id: "AUT50", name: "Descuento Autorizado por Directiva 50%", value: 100000, discount: 50},
{id: "BBVA", name: "BBVA", value: 200000, discount: 0},
{id: "Bomberos", name: "Convenio con los Bomberos UCV", value: 	0, discount: 100},
{id: "CIENS", name:"Convenio con la Facultad de Ciencias", value: 100000, discount: 50},
{id: "CP", name:"Centro Plaza", value: 200000	0},
{id: "DERECHO", name:"Converio con Fac de Derecho", value: 100000, discount: 50},
{id: "DTIC", name:"Convenio con DTIC", value: 0, discount: 100},
{id: "EEI", name:"Convenio con la Escuela de Estudios Internacionales", value: 100000, discount: 50},
{id: "EIM", name:"Convenio con la Escuela de Idiomas Modernos", value: 100000, discount: 50},
{id: "EP", name:"Convenio Escuela de Estudios Políticos", value: 200000, discount: 0},
{id: "EXO", name:"Exonerado", value: 0, discount: 100},
{id: "FHE", name:"Convenio con la Facultad de Humanidades y Educación", value: 100000, discount: 50},
{id: "ING", name:"Convenio con la Facultad de Ingeniería", value: 100000, discount: 50},
{id: "REG", name:"Ingreso General", value: 200000, discount: 0},
{id: "SENIAT", name:"SENIAT", value: 200000, discount: 0},
{id: "SENIAT50", name:"SENIAT 50%", value: 100000, discount: 50},
{id: "UCV", name:"Comunidad Universidad Central de Venezuela", value: 140000, discount: 30}])