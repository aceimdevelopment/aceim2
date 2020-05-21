# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# 10.times { Item.create!(name: "Item", description: "I am a description.") }

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
