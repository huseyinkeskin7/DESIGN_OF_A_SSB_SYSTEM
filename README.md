# DESIGN_OF_A_SSB_SYSTEM
# Türkçe
Bu projede yazılan MATLAB kodu, analog veri karıştırma (scrambling) teknikleri kullanılarak tek yan bant (SSB) modülasyon sisteminin güvenli ses iletişimi için nasıl kurulacağını göstermektedir. İlk olarak, giriş ses sinyali analog scrambler (karıştırıcı) yardımıyla karıştırılır. Ardından, bu karıştırılmış sinyal SSB modülasyonu ile taşıyıcı frekansa bindirilir ve gönderici kısmı tamamlanır.
Alıcı kısmında ise önce SSB demodülasyonu yapılır, ardından analog descrambler (çözücü) yardımıyla orijinal ses sinyali geri elde edilir. Kodun ikinci bölümünde bu işlemler gerçek bir konuşma sinyali ile gerçekleştirilmiş ve iletişimin güvenli şekilde sağlandığı gözlemlenmiştir.

# English
This MATLAB code demonstrates how to implement a secure single sideband (SSB) communication system using analog data scrambling techniques. Initially, the input voice signal is scrambled with an analog scrambler. Then, the scrambled signal is modulated onto a carrier frequency using SSB modulation, completing the transmitter section.
In the receiver section, SSB demodulation is performed first. Afterward, the analog descrambler is used to recover the original voice signal. In the second part of the code, these operations are repeated with a real speech signal, and it is observed that secure voice transmission is successfully achieved.
