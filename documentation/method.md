# Methodology
This project implement the Benfit of the Doubt (BOD) composite indices as introduced in Cherchye _et al._ (2006). The sample data are the base stats of Pokémon Generation I (Game Freak 1996). 

The BOD index to be constructed is a relative score up to 100 points, comparing the relative positions of the overall strength across individuals. Consider that 

$$
  \textnormal{Overall Score of p} = w_{pi}x_{pi}
$$

is the (absolute) power of a Pokémon _p_, where $x_{pi}$ is the score of the Pokémon in the item _i_, and $w_{pi}$ is the weight on each item _i_ that is specific to the Pokémon _p_. Put it in another word, $w_{pi}$ measures the ''importance'' that this Pokémon attaches to each item. When this Pokémon would like to compare itself with others, it keeps applying the same weight but look at the score of another Pokémon to see what is the distance from the peer. Say Meowth of the Rocket Team attaches a higher value to money than physical strength. When it compare itself with Kojirou who is rich but weak in strength, it still apply its own view point on money and feels envy -- although Kojirou himself doesn't attach as high importance to money as what is with Meowth. So when an individual _p_ compares itself with _q_, the relative score is given by: 

$$
  \textnormal{Relative Position p vs q} = 
  \frac{\sum_i w_{pi}x_{pi}}
  {\sum_i w_{pi}x_{qi}}
$$

BOD can be considered as the relative comparison of a Pokémon _p_ with the frontier in its own eye, given by:

$$
  p \textnormal{'s Relative Position v.s. Best in Class} = 
  \frac{\sum_i w_{pi}x_{pi}}
  {\max_{q} \{\sum_i w_{pi}x_{qi}\} } 
$$

There are several items that the individual can invest in. The basic idea is that an individual's resource is limited. If the choice is made optimally, the individual will choose to first deploy resource to the item with the highest importance to itself. Say a particular Pokémon might think the Attack Point is the most important to it, and another might think Speed is more important. The former is going to allocate first its resources to AP, while the later will first go for SP. If one believe the story above, when evaluating the strength etc of an individual one should not simply take the simple average of all items, or apply a weighted average of all items with homogeneous weight for everyone, but instead, it would be appealing to have customized weight to each individual, to the benefit of the items that the individual is the stronggest at, such that the above equation is maximized:

$$
  BOD_{p} = \max_{w_{pi}}\{
  \frac{\sum_i w_{pi}x_{pi}}
  {\max_{q} \{\sum_i w_{pi}x_{qi}\} }
  \} \times 100\%.
$$

This corresponds to equation (4) in Cherchye _et al._ (2006).

# Implementation
## Unrestricted BOD
When implementing, it is easier to transform the equation (4). It boils down to a linear programming prblem by enforcing the denominator to equal 1 and to maximize the term on the numerator. The question can be stated as:

$$
\max_{w_{pi}}: \sum_i w_{pi}x_{pi} \times 100,
$$

$$
\textnormal{s.t.}: \sum_i w_{pi}x_{qi}\leq 1, \forall q \textnormal{ in the sample, and}
$$

$$
w_{pi} \geq 0, \forall w_{pi}.
$$

## Boundary on an item's contribution share
It would be often attractive consideration to put constraints to bound the share of contributions an individual can derive from a certain item. For example, a Pokémon's attack point is essential so the weight cannot go zero, but it cannot rely everything on attack because other things like defense can be also important. Assume that we consider attack point can consists a maximum share of 75% and minimum 25% in the overall score for a Pokémon, further constraints can be added as:

$$
0.25 \leq
\frac{w_{p,AP}x_{p,AP}}
{\sum_i w_{pi}x_{pi}}
\leq 0.75
$$

The above equation is non-linear but can be re-arranged in the way that:

$$
0.25 \sum_i w_{pi}x_{pi} - w_{p,AP}x_{p,AP} \leq 0
$$

$$
w_{p,AP}x_{p,AP} - 0.75 \sum_i w_{pi}x_{pi} \leq 0.
$$


## Boundary on item group's contribution share
Similarly, we may not put constraints on one particular item but set boundary based on a group of items. Say Attack and Defense forms a group "physical strength", and the group's contribution to overall score should be between 30% to 80%. The constraint is 

$$
0.3 \leq
\frac{w_{p,AP}x_{p,AP} + w_{p,DF}x_{p,DF}  }
{\sum_i w_{pi}x_{pi}}
\leq 0.8,
$$

and it can be practically implemented as

$$
0.3 \sum_i w_{pi}x_{pi} - w_{p,AP}x_{p,AP} - w_{p,DF}x_{p,DF} \leq 0
$$

$$
w_{p,AP}x_{p,AP} + w_{p,DF}x_{p,DF} - 0.8 \sum_i w_{pi}x_{pi} \leq 0.
$$

Practically, it is usually a good idea to decide the number of groups and which items will form a group based on clustering techniques, like principal factor analysis (PCA). 


# Example
TO BE IMPLEMENTED.

## Benefit of the Doubt and ''Bottleneck''
A common misunderstanding is that the BOD algorithm will optimally select weights to each item, such that the BOD score of an individual represents the overall performance that takes care of weakest factor as bottleneck. This is not necessarily the case, depending on the method one is using. 

The unrestricted BOD does _not_ feature a bottleneck adjustment. Instead, it tends to reward ''unbalanced development'' for those individuals with all resources devoted to a single item. With the eyes on the above equation for unrestricted BOD, a conclusion will be that if a Pokémon _p_ has the highest Speed among all, it will always get a BOD score of 100 (i.e. the maximum) even it is extremely weak in all other items. Why is it so? One can verify that in the unrestricted BOD, the maximization process in linear programming will assign all weights to its Speed (more specificly, $w_{p,SP}=1/x_{p,SP}$), while $w_{pi}=0$ for all other four items.

One can verify that this will met the constraint: if $w_{p,SP}$ is now the only positive, then $\sum_i w_{pi}x_{qi} \equiv w_{p,SP}x_{q,SP}$. But we know this Pokémon has the highest Speed among all, the maximum possible value is reached by the _p_ itself instead of any other Pokémon $q\neq p$. From $w_{p,SP}x_{p,SP}\leq 1$ we therefore have $w_{p,SP}=1/x_{p,SP}$. Insert it into the target of maximization and we have $\sum_i w_{pi}x_{pi} \times 100 = w_{p,SP}x_{p,SP} \times 100 = 100$. 

The above may sound twisting and strange, but from a theoretical perspective it is correct "when unrestricted". Say, you have a blank Pokémon with 10 base points on each item, and additional 200 points to be assigned freely. If a trainer believe that being [fastest is the only truth to victory](https://www.youtube.com/watch?v=yVQWJeLUxSk), what will she or he do? In absence of any other concern, it would be indeed optimal to allocate all the 200 points to Speed. But in a real Pokémon game, however, such extreme allocation is often undesirable. Even if one would bet on Focus Sash to let [Magikarp use Flail](https://www.youtube.com/watch?v=y-PArgnvqQ4), alongside Speed it is still necessary to have HP>24 to ensure that Flail is able to sweep the entire squad of the opponent. 

For real world applications, it is therefore often attractive if one do let the BOD score behave in a way that will not assign weight solely to only one item, and can feature a bottleneck effect to "punish" individuals who is overall OK but extremely weak in one or few items. To do so, one should use the BOD methods with  boundary. Setting a upper bound on an item will put a cap on the maximum share that this single (group of) item may contribute to the overall BOD score. Setting a lower bound would implement a bottleneck effect in relation to the (group of) item, or in another word, put a cap on the other items from which they can contribute to the overall score of a Pokémon.

Author: Xianjia Ye (Univerisity of Groningen)

## Reference
Cherchye, L, Moesen, W. and van Puyenbroeck, T. (2007). "An introduction to 'Benefit of the Doubt' comoposite indicators". _Social Indicators Research_, Vol. 82, pp. 111-145.

Game Freak. (1996). _Pokémon Red/Blue_. Published by Nintendo. 
