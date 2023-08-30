#Google CTF 2023 the first crypto chall
from Crypto.Util.number import *

m = 8311271273016946265169120092240227882013893131681882078655426814178920681968884651437107918874328518499850252591810409558783335118823692585959490215446923
a = 99470802153294399618017402366955844921383026244330401927153381788409087864090915476376417542092444282980114205684938728578475547514901286372129860608477
b = 3910539794193409979886870049869456815685040868312878537393070815966881265118275755165613835833103526090552456472867019296386475520134783987251699999776365

class LCG:
    lcg_m = a
    lcg_c = b
    lcg_n = m

    def __init__(self, lcg_s):
        self.state = lcg_s

    def next(self):
        self.state = (self.state * self.lcg_m + self.lcg_c) % self.lcg_n
        return self.state


seed = 211286818345627549183608678726370412218029639873054513839005340650674982169404937862395980568550063504804783328450267566224937880641772833325018028629959635
lcg = LCG(seed)
primes_arr = []
primes_n = 1
while True:
    for i in range(8):
        while True:
            prime_candidate = lcg.next()
            if not isPrime(prime_candidate):
                continue
            elif prime_candidate.bit_length() != 512:
                continue
            else:
                primes_n *= prime_candidate
                primes_arr.append(prime_candidate)
                break

    # Check bit length
    if primes_n.bit_length() > 4096:
        print("bit length", primes_n.bit_length())
        primes_arr.clear()
        primes_n = 1
        continue
    else:
        break
enc_flag_in_int = 10055254817050606245078153964646282242016712923067254347101179149126378075855557984444414832883736339376030157110423579564741992729154299416090391420673495156302631715184952278776857766630468957122329097655361855535821012593032248081430756595979234217592639981583078092538703328639975720325313111710799382457518258395223013618693662530651002257735692525447623832044481622746940704891677411801830135208674961935858773315372231561192043480490442131198776900157673286071484062314825613878317224314010080367732125262343817670331752772111584576200940020826867275528178570726846114159707083421681687680774090415554465967672606070482724934208764047203678460712508708647282278957530279325745679169141484341188338798865804249431810624874933179557415020940131495920677234399770552248514559162081906594199582776738188034083043493761702452697831623872823660942359263083188815075033808190977768416992965529025751418921326743349959309259035744651361425225375254040098604181809300720180774470683783401044114415010132938312251359225043793491588434652587442607783449289445897392963984411136478966903796587388294245194356306941496594442766170466555151436915204077741696524766661045685287856846632686882652415672316507235603192046053967442247947850572

n = 1
for j in primes_arr:
    n *= j

phi = 1
for k in primes_arr:
    phi *= (k - 1)

d = pow(65537, -1, phi)

flag_in_int = pow(enc_flag_in_int, d, n)

print(long_to_bytes(flag_in_int))