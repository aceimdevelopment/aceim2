# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# 10.times { Item.create!(name: "Item", description: "I am a description.") }
Bank.create([{id: '0102', name: 'Banco de Venezuela'}, {id: '0134', name: 'Banesco'}])

BankAccount.create(id: 'FUNDEIM', number: '0102-0140-34000442688-4', holder: 'FUNDEIM (RIF: J-30174529-9)', bank_id: '0102')

# User.create(email: 'moros.daniel@gmail.com', name: 'Daniel', last_name: 'Moros', number_phone: '04242603202', password: 'd15573230')

Language.create([{id: 'IN', name: 'Inglés'}, 
	{id: 'AL', name: 'Alemán'}, 
	{id: 'FR', name: 'Francés'}, 
	{id: 'IT', name: 'Italiano'},
	{id: 'PG', name: 'Portugués'}])

Level.create([
{id: "AI", name: "Avanzado I"},
{id: "AII",  name: "Avanzado II"},
{id: "AIII",  name: "Avanzado III"},
{id: "BI", name: "Básico I"},
{id: "BII",  name: "Básico II"},
{id: "BIII", name: "Básico III"},
{id: "CA", name: "Conversación Avanzado"},
{id: "CB", name: "Conversación Básico"},
{id: "CI", name: "Conversación Intermedio"},
{id: "MI", name: "Intermedio I"},
{id: "MII",  name: "Intermedio II"},
{id: "MIII", name: "Intermedio III"},
{id: "NI", name: "Nivelacion"}])

Agreement.create([
{id: "ADM", name: "Convenio Escuela de Administración", value: 0, discount: 100},
{id: "Administra", name: "Escuela de Administración 50%", value: 100000, discount: 50},
{id: "AUT30", name: "Descuento Autorizado por Directiva 30%", value: 140000, discount: 30},
{id: "AUT50", name: "Descuento Autorizado por Directiva 50%", value: 100000, discount: 50},
{id: "Bomberos", name: "Convenio con los Bomberos UCV", value: 	0, discount: 100},
{id: "CIENS", name:"Convenio con la Facultad de Ciencias", value: 100000, discount: 50},
{id: "CP", name:"Centro Plaza", value: 200000, discount: 0},
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


Course.create([
{language_id: "AL", level_id: "AI", grade: 7},
{language_id: "AL", level_id: "AII", grade: 8},
{language_id: "AL", level_id: "BI", grade: 1},
{language_id: "AL", level_id: "BII", grade: 2},
{language_id: "AL", level_id: "CA", grade: 9},
{language_id: "AL", level_id: "CB", grade: 3},
{language_id: "AL", level_id: "CI", grade: 6},
{language_id: "AL", level_id: "MI", grade: 4},
{language_id: "AL", level_id: "MII", grade: 5},
{language_id: "AL", level_id: "NI", grade: 0},
{language_id: "FR", level_id: "AI", grade: 7},
{language_id: "FR", level_id: "AII", grade: 8},
{language_id: "FR", level_id: "BI", grade: 1},
{language_id: "FR", level_id: "BII", grade: 2},
{language_id: "FR", level_id: "CA", grade: 9},
{language_id: "FR", level_id: "CB", grade: 3},
{language_id: "FR", level_id: "CI", grade: 6},
{language_id: "FR", level_id: "MI", grade: 4},
{language_id: "FR", level_id: "MII", grade: 5},
{language_id: "FR", level_id: "NI", grade: 0},
{language_id: "IN", level_id: "AI", grade: 9},
{language_id: "IN", level_id: "AII", grade: 10},
{language_id: "IN", level_id: "AIII", grade: 11},
{language_id: "IN", level_id: "BI", grade: 1},
{language_id: "IN", level_id: "BII", grade: 2},
{language_id: "IN", level_id: "BIII", grade: 3},
{language_id: "IN", level_id: "CA", grade: 12},
{language_id: "IN", level_id: "CB", grade: 4},
{language_id: "IN", level_id: "CC", grade: 13},
{language_id: "IN", level_id: "CI", grade: 8},
{language_id: "IN", level_id: "MI", grade: 5},
{language_id: "IN", level_id: "MII", grade: 6},
{language_id: "IN", level_id: "MIII", grade: 7},
{language_id: "IN", level_id: "NI", grade: 0},
{language_id: "IT", level_id: "AI", grade: 7},
{language_id: "IT", level_id: "AII", grade: 8},
{language_id: "IT", level_id: "BI", grade: 1},
{language_id: "IT", level_id: "BII", grade: 2},
{language_id: "IT", level_id: "CA", grade: 9},
{language_id: "IT", level_id: "CB", grade: 3},
{language_id: "IT", level_id: "CI", grade: 6},
{language_id: "IT", level_id: "MI", grade: 4},
{language_id: "IT", level_id: "MII", grade: 5},
{language_id: "IT", level_id: "NI", grade: 0},
{language_id: "PG", level_id: "AI", grade: 7},
{language_id: "PG", level_id: "AII", grade: 8},
{language_id: "PG", level_id: "BI", grade: 1},
{language_id: "PG", level_id: "BII", grade: 2},
{language_id: "PG", level_id: "CA", grade: 9},
{language_id: "PG", level_id: "CB", grade: 3},
{language_id: "PG", level_id: "CI", grade: 6},
{language_id: "PG", level_id: "MI", grade: 4},
{language_id: "PG", level_id: "MII", grade: 5},
{language_id: "PG", level_id: "NI", grade: 0}
])