# Methodology
This project implement the Benfit of the Doubt (BOD) composite indices as introduced in Cherchye _et al._ (2006). The sample data are the base stats of Pokémon Generation I (Game Freak 1996). 

The BOD index to be constructed is a relative score up to 100 points, comparing the relative positions of the overall strength across individuals. Consider that 

$$
  \textnormal{Power}_p = \w_{pi}x_{pi}
$$

is the (absolute) power of a Pokémon _p_, where $x_{pi}$ is the score of the Pokémon in the item _i_, and $w_{pi}$ is the weight on each item _i_ that is specific to the Pokémon _p_. Put it in another word, $w_{pi}$ measures the ''importance'' that this Pokémon attaches to each item. When this Pokémon would like to compare itself with others, it keeps applying the same weight but look at the score of another Pokémon to see what is the distance from the peer. Say Meowth of the Rocket Team attaches a higher value to money than physical strength. When it compare itself with Kojirou who is rich but weak in strength, it still apply its own view point on money and feels envy -- although Kojirou himself doesn't attach as high importance to money as what is with Meowth. So when an individual _p_ compares itself with _q_, the relative score is given by: 

$$
  \textnormal{Relative Position p v.s. q} = 
  \frac{\sum_i w_{pi}x_{pi}}
  {\sum_i w_{pi}x_{qi}}
$$

BOD can be considered as the relative comparison of a Pokémon _p_ with the frontier in its own eye, given by:

$$
  p \textnormal{'s Relative Position v.s. Best in Class} = 
  \frac{\sum_i w_{pi}x_{pi}}
  {\max_{q} \{\sum_i w_{pi}x_{qi}\} } 
$$

There are several items that the individual can invest in. The basic idea is that an individual's resource is limited. If the choice is made optimally, the individual will choose to first deploy resource to the item with the highest importance to itself. Say a particular Pokemon might think the Attack Point is the most important to it, and another might think Speed is more important. The former is going to allocate first its resources to AP, while the later will first go for SP. If one believe the story above, when evaluating the strength etc of an individual one should not simply take the simple average of all items, or apply a weighted average of all items with homogeneous weight for everyone, but instead, it would be appealing to have customized weight to each individual, to the benefit of the items that the individual is the stronggest at, such that the above equation is maximized:

$$
  BOD_{p} = \max_{w_{pi}}\{
  \frac{\sum_i w_{pi}x_{pi}}
  {\max_{q} \{\sum_i w_{pi}x_{qi}\} }
  \} \times 100\%.
$$

This corresponds to equation (4) in Cherchye _et al._ (2006).

When implementing, it is easier to transform the equation (4). It boils down to a linear programming prblem by enforcing the denominator to equal 1 and to maximize the term on the numerator. The question can be stated as

$$
\max_{w_{pi}} \sum_i w_{pi}x_{pi} \times 100,
$$

$$
\textnormal{s.t.}: \sum_i w_{pi}x_{qi}, \forall q \textnormal{ in the sample.}
$$


## Need to eat something. To be continued...


Author: Xianjia Ye (Univerisity of Groningen)

## Reference
Cherchye, L, Moesen, W. and van Puyenbroeck, T. (2007). "An introduction to 'Benefit of the Doubt' comoposite indicators". _Social Indicators Research_, Vol. 82, pp. 111-145.

Game Freak. (1996). _Pokémon Red/Blue_. Published by Nintendo. 
