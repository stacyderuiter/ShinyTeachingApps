---
title: "About the blue whale data"
output: html_document
---

The data presented here are data on the dive behavior of the Northern bottlenose whale.  This dataset includes observations on 556 dives performed by 14 individual bottlenose whales tagged with animal-borne data-loggers called  [DTAGs](http://soundtags.st-andrews.ac.uk/dtags/) during scientific experiments.  Part of the goal of the studies was to understand how the whales behave underwater, during dives.  As part of that work, researchers measured a number of variables to characterize each dive performed by the whales.

These data were part of [a study of the behavioral responses of northern bottlenose whales to military sonar sounds](http://rsos.royalsocietypublishing.org/content/2/6/140484), published in 2015 by Miller and colleagues.  For more information about the whales, the study, and its findings, please consult the article (web link above; citation at the end of this document).

The data are to be freely available on the [Dryad digital repository](http://http://datadryad.org/).

The variables include:


* **Dive Depth** Maximum depth (in meters) attained by the whale during the current dive.
* **Dive Duration** Duration (in seconds) of the current dive.
* **Descent (Ascent) Duration** Duration, in minutes, of the descent (ascent) portion of the dive.
* **Descent (Ascent) Rate** The vertical speed of the whale during the descent (ascent) portion of the dive.
* **Descent (Ascent) Pitch** The average pitch of the whale's body during the descent (ascent) portion of the dive.  The pitch is zero radians when the whale is horizontal in the water (dorsal fin up and head pointing forward), negative when the whale's head points downward, and positive when the whale's head points upward.
*  **Variance in Pitch** This value quantifies the variability of the whale's body pitch.  It ranges from zero (no variability) to one (pitch varies randomly).
* **Post-dive Surface Interval** Duration (in minutes) that the whale spent at the surface after the dive, before beginning the next dive.
*  **Variance in Heading** This value quantifies the variability of the whale's compass heading (which direction it was 'pointing' its body), as measured by high-resolution accelerometers and magnetometers on the tag.  It ranges from zero (highly directed travel -- no variability of heading) to one (heading varies randomly).
*  **Variance in Roll** This value quantifies the variability of the whale's roll (whether it has rotated about the long axis of its body -- for example, roll of pi radians or 180 degrees would be belly-up, dorsal fin down).  It ranges from zero (no variability) to one (roll varies randomly).
* **Normalised ODBA** A relative measure of "how much the whale is moving", or (roughly) how much energy it is using.  Technically, this is a quantity called the Overall Dynamic Body Acceleration, as measured by accelerometers in the DTAG.  The values have been normalized for each whale studied so that they are comparable from whale to whale; this normalization is necessary because the absolute value of ODBA changes depending on where the tag is placed on the whale's body.
* **Wiggliness** This metric measures the shape of the whale's depth profile as a function of time.  It ranges from zero to one.  Zero indicates a totally smooth profile with no inflection points; one indicates that the whale is changing its vertical direction (up or down) nearly constantly, resulting in a dive profile with many inflection points.


Reference:
P. J. O. Miller, P. H. Kvadsheim, F. P. A. Lam, P. L. Tyack, C. Curé, S. L. DeRuiter, L. Kleivane, L. D. Sivle, S. P. van IJsselmuide, F. Visser, P. J. Wensveen, A. M. von Benda-Beckmann, L. M. Martín López, T. Narazaki, and S. K. Hooker. 2015. First indications that northern bottlenose whales are sensitive to behavioural disturbance from anthropogenic noise. R. Soc. Open Sci. 2: 140484; DOI: 10.1098/rsos.140484. 