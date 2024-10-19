## EcoChoices documentation

# Welcome to the documentation of the EcoChoices app!

You can find here details about the EcoChoices app, from a high-level vision to low-level implementation decisions, a kind of Software Development Report, organized by type of activities:

- [Getting started](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC01T3/blob/main/proj_app/README.md)
- [Business modeling]()
  - [Product Vision](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC01T3/blob/main/Project%20Vision.md)
  - [Elevator Pitch](#Elevator-Pitch)
- [Requirements](#Requirements)
  - [User stories](https://github.com/orgs/FEUP-LEIC-ES-2023-24/projects/13)
  - [Domain model](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC01T3/blob/main/Domain%20Model.jpeg)
- [Architecture and Design]()
  - [Logical architecture]()
  - [Physical architecture]()
  - [Vertical prototype]()
- [Unit Tests](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC01T3/tree/main/proj_app/test)
- [Project management]()

### Features
- [X] User can Register/Login
- [X] The app recommends products that have the highest "eco-score" to the user
- [X] The user can add products to the database
- [X] Make lists with products the user desire
- [X] Switch a product on a list with a higher "eco-score" one
- [X] Calculate the mean of the "eco-score" of the list
- [X] Add notes on products
 
### Elevator Pitch

"Boa tarde a todos,

Imaginem um mundo onde cada escolha que fazemos no supermercado pode ajudar a salvar o planeta. É exatamente isso que a nossa aplicação, EcoChoices, propõe. Com o nosso mote "Juntos Por Um Mundo Melhor", temos como objetivo transformar a forma como fazemos compras.

EcoChoices é uma aplicação que guia os consumidores na direção de escolhas mais sustentáveis com base na escala de sustentabilidade “eco-score”. 

Como funciona? Simples: ao organizar a sua lista de compras, a nossa aplicação analisa os produtos com base na sua pontuação de sustentabilidade e sugere alternativas mais verdes para cada item, permitindo aumentar a pontuação da lista com um simples toque. 

O utilizador pode substituir itens rapidamente, garantindo compras mais conscientes e responsáveis, além de permitir comentários pessoais nas listas para futuras referências.

Por último mas não menos importante, EcoChoices permite a introdução de novos produtos na nossa base de dados, promovendo transparência e colaboração entre os utilizadores.

Juntos, podemos fazer escolhas mais inteligentes e contribuir para um futuro mais verde. 
EcoChoices é mais do que uma aplicação; é um passo rumo a um mundo melhor.

Obrigado!"

Sprint 3 was for sure the one where we worked the hardest. We added new features, redesigned a lot of areas of the app making it more clean overall. However, we added a feature that needed a little more time to be as we wanted which is the "Add product". We should've implemented an Admin status for some users who could either do two things:
  - Accept new products suggested by users;
  - The products that were added on the database could only be done by them;
We also would like to made an algorithm to calculate the eco score instead of brute force choosing them. Overall the app does it's purpose but could for sure be more polished.


# Contributors

- Gonçalo Barroso up202207832
- Hugo Cruz up202205022
- João Martinho up202204883
- Tiago Oliveira up202009302
- Tomás Martins up202108639
