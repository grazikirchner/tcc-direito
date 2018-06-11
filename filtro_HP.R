library(BETS)
library(mFilter)
library(ggplot2)
library(scales)

pib <- BETS.get(22099, from = '1996-03-01', to ='2017-06-01')
pib_sa <- BETS.get(22109, from = '1996-03-01', to ='2017-06-01')

hp <- hpfilter(pib_sa, type='lambda', freq=1600)

dates <- seq(as.Date('1996-03-01'), as.Date('2017-03-01'),
             by='3 month')

df <- data.frame(time = dates, pib = pib, pibsa = pib_sa, pot = hp$trend)
colnames(df) <- c('time', 'pib', 'pibsa', 'pot')

ggplot(df, aes(x=time)) +
  annotate("rect", fill = "gray80", alpha = 0.5,
           xmin = as.Date('2008-09-01'),
           xmax = as.Date('2009-03-01'),
           ymin = -Inf, ymax = Inf)+
  annotate("rect", fill = "gray80", alpha = 0.5,
           xmin = as.Date('2014-12-01'),
           xmax = as.Date('2016-12-01'),
           ymin = -Inf, ymax = Inf)+
  geom_line(aes(y=pibsa, colour='PIB Efetivo'), size=.9)+
  geom_line(aes(y=pot, colour='PIB Potencial'), size=.8)+
  scale_colour_manual('', values=c('PIB Efetivo'='darkblue',
                                   'PIB Potencial'='red'))+
  theme(legend.position = 'top')+
  labs(title='PIB Efetivo vs. PIB Potencial',
       caption='Fonte: analisemacro.com.br com dados do IBGE.')+
  xlab('')+ylab('Número Índice')+
  scale_x_date(breaks = date_breaks("2 years"),
               labels = date_format("%Y"))


df2 <- data.frame(time=dates, hiato=hp$cycle)

ggplot(df2, aes(x=dates, y=hiato))+
  geom_area(stat='identity')+
  scale_x_date(breaks = date_breaks("2 years"),
               labels = date_format("%Y"))+
  xlab('')+ylab('Variação do Número Índice')+
  labs(title='Hiato do Produto')
