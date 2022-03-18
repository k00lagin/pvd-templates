<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY laquo "&#171;">
	<!ENTITY raquo "&#187;">
	<!ENTITY nbsp "&#160;">
	<!ENTITY mdash "&#8212;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" 
xmlns:tns="http://rosreestr.ru/services/v0.26/TInterdepStatement" 
xmlns:doc="http://rosreestr.ru/services/v0.26/commons/Documents" 
xmlns:obj="http://rosreestr.ru/services/v0.26/commons/TObject" 
xmlns:subj="http://rosreestr.ru/services/v0.26/commons/Subjects" 
xmlns:stCom="http://rosreestr.ru/services/v0.26/TStatementCommons" 
xmlns:adr="http://rosreestr.ru/services/v0.26/commons/Address">
	<!--Версия: 0.12-->
	<!--10.11.2016 -->
	<!--Версия: 0.13-->
	<!--12.12.2016-->
	<!--Версия схем: 0.14-->
	<!--24.01.2017-->
	<!--Версия схем: 0.15-->
	<!--09.02.2017  -->
	<!--Версия схем: 0.16-->
	<!--20.02.2017-->
	<!--Версия схем: 0.17-->
	<!--21.03.2017-->
	<!--Версия схем: 0.18-->
	<!--04.04.2017-->
	<!-- Доработка логики отображения Адреса: Для ПВД - по-старому, для внешних систем - выводим всё - и Адрес и note (неформальное описание) -->
	<!--11.08.2017-->
	<!-- Анализ бесплатности УРД, что влияет на появление текста в реквизите «Дата окончания срока регистрации» -->
	<!--20.09.2017-->
	<!--Версия схем: 0.25-->
	<!--16.10.2018-->
	<!--Шрихкод номера в заголовке-->
	<!--23.03.2020-->
	<!--Отображение нот. удостоверения для всех документов описи-->
	<!--07.03.2020-->
	<xsl:strip-space elements="*"/>
	<xsl:output method="html" doctype-system="about:legacy-compat" indent="yes" encoding="utf-8"/>
	<xsl:variable name="delimiter" select="','"/>
	<xsl:variable name="smallcase" select="'абвгдеёжзийклмнопрстуфхцчшщьыъэюя'"/>
	<xsl:variable name="uppercase" select="'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЫЪЭЮЯ'"/>

	<xsl:variable name="objects" select="//node()/tns:objects/stCom:object"/>
	<xsl:variable name="owner" select="//node()/tns:subjects/tns:owners/tns:owner"/>
	<xsl:variable name="declarant" select="//node()/tns:subjects/tns:declarant"/>
	<xsl:variable name="signCount" select="count($owner)+count($declarant)"/>
	<xsl:variable name="receiptCodes" select="'-558501030100-558502020100-558503000100-558601000000'"/>
	<!-- 558501030100 гку
	558502020100 грп
	558503000100 гку+грп
	558601000000 извещение о соглас местополож улиц -->

	<!-- PNG Упаковынные вертикальные надписи для таблицы-->
<xsl:variable name="col1src" select="'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAABNCAYAAACWhFUTAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsQAAA7EAZUrDhsAAAIzSURBVFhH3ZfRaQJBEIYtwRJiCUIqCKQBIUUEKwh2EKwg+Go6MA0EbCDgoynBEjZ85n6dndlj10swkA8Gb5f5b2Z2Z+/OURrI7wgPh0OaP87TeDzuZtJxvPvYdaMzmRCnyc0kjUZ5ItPbaXd1JvNAsP/cB6EfQzajFK3j9n1bFy6eFmn1sjo5bt42x5sx7wm3wgmhjLpZNE/MoZFMWKqFaKX5IOwzTxBS4/J5eTLV7MlmcLSwFXSNn4d4qw6cleZFQloPAca1JxPe3d91V9/1imqNONAtajN+m1oOhz7zBKFvr9JpgWzG1mgpzYeIqlHGuCnVPvMEoWqUc1ONpCass50XIaLouxZByBONVeSaX8ZNQn+seHRUhT/axxJNqapG2cU1cj2oRutcrZEIwgrtvMiEOPuDfL0mF//xIPPIJzWiwUUHGWdaTQuleUuIKHil037N70fb5IxLny8QhNc9yIOFvkas+SBb0UXCEoOFJYJQNc4eZsftYHtodE8mROCh3eyHr6jmRmTMU40IWmG6SIQafcsRjXma3hKEurvsb/axSaj9oyZ+mw4yNVkQsVgI/eOjnJtBEf2/gaKQhxUR9LAqkQlx1L7JbBRLJsSJlFgYImJaLE8mROQXgSyqTU5qHi2OJ5thO9av6250rpm282RC3hukpcNMJMbVP55AFBYDIYvF1pQIqZYozWdC7RsRZYyri4MDd7fW/NIpMVjomwKqwqYGwKHPPEHoP1fopChM6Quaq+ElqhSaPwAAAABJRU5ErkJggg=='"/>
<xsl:variable name="col2src" select="'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAvCAIAAABc2mwVAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAF2SURBVEhLtZTdacNAEIRVgkqISzCkAkMaMLiI4AqCOwiuIPjV7sBpIOAGAn50SlAJyodm77gfbhUCGu5htTeam91bqRv/jP9Sj+9HiwLSTEbtuu76eb193bSIydheTa1hezX1/n3fvGyQ5PHx82hSI2P9vB6GIWaEUlXB6eN0eDvA9gyghwEW8epp5VERo0Fa+9d9k4qYRQFpplS1KMAzEL2yiD3qdrft+16O572qU2lGyKhxOGCo+TEDSgMal/PlTFOR97zWsL2aqqsXvHFJixCaZaGxzGhbNMHzWlCBuivMUD1VSo5rZlwWGG3AbTEASNJUSwVkVLqjT0+In7iQUZlrtvlr6FF2FYOMihLC9jCBjEU11aIJ3m1xHEv+KAvfWNIWyKiQ6A5KgleWwL3PN4uPyaIAtC0qqJxo0QS0m1QORZi+Ujuv8e+AbXsFFZfUQRNUOy9486qSdS5x0wAbNWyvpmKXQ7UYsSY1LUJoluVjCeo4/gJYbhiPs0yEXQAAAABJRU5ErkJggg=='"/>
<xsl:variable name="col3src" select="'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAABpCAIAAACF24VkAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAPUSURBVFhHzZcxT1RBEMcPY2sC38ArITYQKI5YQbCAjsRGStREKUlMFFpiomAFFgolfgPOgoRGwxUSKDRHYcIzsTW5S/wA54/339vd2eM9uEiMv1we82Zm583Ozr63DHQ6ncrVuOH+XoEy1+l7004SJCCQz7Izd9PpLD1Ziq1gXDFLll+Z6/z9+e1321wHBwebX5tTM1POlmPGtVotnBhz+OnQqSJM1NHxUX4EJh7D1l+tO1tO6ooHMk9HLss1rgDeha69+SWasLDtdnvn/Y5ksfV2i+e4G9AIYCpOlUMpqJqz5ZhcmRMDyJJbnp4kYFy57n7Y9WtWvV2VIEwCWh48Vp6v8HQN9oQbnquaI+BNrjxBJmHGJRSuFmGclMMUkwRCa/vGg/rHerV6noO7F25IHoYnMoAremamfvAEV01fS6/SSuMJroqkkFyR42dC6IGBgQEab2hoSLfZ9yz7kXkrGNfYAIkmVIDMnNQl0Zio5OcTYPprL9cKE2A9yU/BenM1FSASgdmGXiNBhBt1J97UQZusrF+1PHiQg9ZCJmFylRDjrWBc9+p7Q7e6S/AzW3iwELuGRyQrDonmglwFchwI+sjVvLXJlekjcGVjSRnIY5/jd5JXeo0IUev7dSd1STQ33d9K5WD/YPXFqtpl4/UG00IjkzDT+s9b26wWuSoSV9o8tsIFufYKIuSqdYpJNYwTyGoXKf+qXYzrVVs7aQ5INCaql0WiMa5xDzCtk6OT2NW0Nm/q4y/HtfHa7Mzs5MSk03oYJ7TpeLWwvLHGE6ISievio8XGUaPxueE1ATckz0l7i11FAxA+toKZloQYbwUzLS2sMJ934Sz9LkG8sK3frbnZOW+FPnI1rnGD9kY1xXJSl7JcsSHwFR4ZHkGo3a3lFocp1vCd4cnapPxIoPBQSqJOytHWdTc50TZsmE23+WaT4wsvL37SFNa1edp8+Pghx4PlZ8t6J5gK9BIvdWGxLtncXhaJxriSmU431IuipoO5Ecg+M+anA0l8ojXZxKhf2cMMkybNL0Y7DNwKa4RgP6mEcTBPcNW+Y4VoGn6MSbyDq3apu8lzReNuckyxvCwSTWgXYpx+O3U3+VdOeQfOQ+eQGcWnnCTKtDCVHXVpWbXpJRVIdhIkGjMtIl3Pe8BsQwyesndWLItkY/axBMZVlRK9n41wIAE+GOGUkWW4SnYwTiQfCUg0aX4lmGKV8y9dOWHFvevQ7IATM1NmbyHof6LCzhqbGOPVQjnbv9pLT8//oSr85xSZFZJNr5nYCmZhJfcKwrhKiCl0jXfBNR1zLqFS+QNrlOOjRBmClQAAAABJRU5ErkJggg=='"/>
<xsl:variable name="col4src" select="'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA0AAAA/CAIAAAC0O9WNAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAJ9SURBVEhLvZU/bhNBFMbXiBbJvgF7BFtwgUhpnC5RUtgnAJ8A5QaQlAYJpQ03iCmQ0oCSBsUFKCmQski0SF6JAyy/3e955o2zdlIgPkXrb+Z9++b9m02nqqrsAXhkv1l2+eXSWIOyLDudji0A/gT4xecL8cVi0X/WT6z22+i2trcgEuVPc6+L5yIa7Y/2DvYG/QHLq/nV0esjmWqYvqo49PrbdbfbZTMEEJCci2jyYoIa33qabUWHSPyePDDbopF6f0keCk7wHMR+UFXO6vV6WuJv/nUerNEfkOj807mWCZrTa4jjBqK6tOdLQBSWlJXp4atDn1bUYcCM+ra4pXhqndm8DmBOfLTWj0ONLeHjS+pyNjvrPVnW5c9iZ7gTrV4n4hGsSf3UexWFbGxXYEsIZjJVNn66XEbLd07en6h43kt7f2kdxSt+FtHqdbgJc1AUxfTdNFijZ18tYW39Ahf8Tnt8gDz8/D3WjzA+GBtr4kNnC8AbgueCjy/pxwqG20NjK/HRAHHwL+bAD+k9c+DRPgeACdDnjEIys7bbIOoQodjd3+UC8McLXhp1GJDaoonP37ck38AFvxPz5e2b7ze2yLLjN8eK1VA7bUA0XHJGkODIA9Pph1Oz+fgAhaCnKDblexf+5kcdhxprsHKPYh58qYxl2ezjLM/z5JNq+sYBB6Hmyf7a75qmkk8CIp5hR4g6+ZAznnB/WtIPf4+KH8Xaex644HdWbeuw6R55/B8dmfoZq0Eegj66zD1EHfNzEPMdPB/QUz4r5e9y8rLu9fTtNN5OyQGchsqgznprS53vkpp7nYhHu87/Pyp+FePROFhjBD47oT3fzXhYP7LsL73sZLlO7hxVAAAAAElFTkSuQmCC'"/>
<xsl:variable name="col5src" select="'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACYAAABYCAIAAAAWdxJIAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAZoSURBVGhD7ZrPa11FFMcTS1cSzAM3BSumu5RuWuyiT920ajHdtdiFQbpoFSQgCN1osyglVZBWN6mCbZZ1I3TXCIZmoySLSrKIpAuhr2AhXQgp+AfUz7vf86YzZ15z513TrPzwvDnz88ycc+bHvXX4yZMnQzvLC/Z3B/lfZTOWf1s2qYfL2f7wGR4eXvp1yRJDQ5v/bJ6YOBFreS4qTYp47ipvz99ujbSU3IlZ4rkjbx5BePz48dz1udHR0T2v7Jl4b0KlXVAZc/PHmyffPyn5wucXNjc3JTdg6pMpqUCwrIpE5ZWvr6iSkugL6hvA/IgjfgiWVZGoVKWgEmK5kNAkF0SaqMpCjfud+652CTTBIzIYTwlWVpGEz6nTp85/er79VptMnH/0naOtVuvOL3esuAwi9uDrB2moZOfPTudBJ9aS6Md5qCFTz7HXxpiolRXj+gSX02eRhP1Jsd6Me3/cw07jB8aJD8sKSLNgcib1yHNqWV9bxzzWe7VC3EpLZokbZFJB1dXfV+MKJewb2zf68ujMpRltQFOfTbUPt2e/m1UpeJWx55uppBMaBntiXjpMOiER2BbDOksiY2fJLBie/ffY+Z/n2YsZKftfsj0WMP3F9PzC/OTpSSWX7nb3FmyL7stfXX6mykOHD42NdUOg0+ms3F1RZiHH3j22uLBoiYyuOv4LaOJAGYMCVRoIt2UGQm9JmTRJCDkSygnjDrgcH7EmRcQVSqAT9tg47OVCJcGrjA/0zl+dyQ8mG6g0KSLphESg1iYlhD4RuuGQBUSaSMsgz6mFJkTQjR9usMYAs1lBD6+S3Yflrx9yA5VcJGgFQbG7WniV8emqy4uVFYMl0YQ+JfNzPkmE7S1UarDhBWUB10miMgRLUNksfPAfivVD3mqWoTZC39ol0CTHyiqey1agQYv8tu5nifMt8R9ueCb1cN5JZskh4O5zeU4tzFIxz/LYP74fwd2httrw+tikgLyTq99eTcbdnWoPy0qxsmJwpEkVrBDXiX+Lli8ReMqXg7K0/DR2YPab2bAficSw4T0N4yg/5JRT6x3vSyVzoRyamBQRd+INy62HKEXgiazMQUFBIPeOn2V8oHPXuvb9tbhCCblhvHe6I+mRb+INtnXXJ7gcP8s4Cc18qYUhWALuyu9VbssLQo13SARIsobYqHRQNzuia73Tx5ec6aiMcwYiP2JdTqIylKFJ+1bevhYMIyPph+xtaX8rKNMRzdsPr0tMt4FhaZJjZRU+fEyKiCuUwCs7L24EBKZi3Pn7pVdJlFJbyc6DDq/Eg6oUaELxxsON8QPj/nWRHgO55xr4MsBWp5jfKmIpli/1Q3ZjKoS2QRmy5fbwKnOsrBjU0AqVQZmbpfcl9SzR76grgU7YT3hTV5IX91s/3Uo66ert4ZLQwJd5Jy7HzxIdCM+6nBVCqC8uLJ796Cwycesi1h/RxHT7SFv6MKyO64FAB0vr3MfnLF19IzFJaLLCRZcCwRLFsPxlKktXn3lNqkgM645v9hGua4NaGO90++0dtDVft0jGLwjra+vkcIKy5VpWAdSP3yxYLeHrlvAqc2hvxWUwUHkE8+o93Plr+9clELGsRcmsUWYpWXiVTkGeMxDofvTwkY8DegyQxBr8mGv8pjAQOJ5W2BaP6FAKdwzhZ4knWJrhzGN5xcdZCSxK1v7G3xtctPS9cubLGTpRaRdpFs7P8ishF4dxLVqF0qEcp2XXxYsXu5or9r6616QKkiMvjrCqVldW22/YNl3L7l27Wy+1aHv87eM8cefa+tqZD89YMZjqHhiWaeEJHDDo8hA0jL8tERn0aYkKb1gGgWVQyQ/B1W4A40arJSoSlaxcpmiJagQotkQx8mUgdqpIE+mGB7nla4mXBFcZRuAGkfRIWaySWbraJdADlsRaPBkxI/DTsL8VVMK2unFRVQ2srBj5giCguULBecfbTUMTDfSBGqofnhq6lVUku084LxH0L2TNPk9gqqcve1v/YyLJ2O7IrkIJeROX4/dYkyLiCtuCv24ROOGnM6EB3K8wLBPgOXd9znID1VwNlwT8b1IxChwWCU9k/MpLo5VV1KhstvtgIQT1xobn7j7elxqjIHzcP+SUwHmJGoTwYZVuEy1OZU18F8DZ3hpphaXFMpu+NL3Vx1GTeuQ5tWCnOALyEz6Z5c6w/f9XUy07rnJo6F+5UJCX4USX7AAAAABJRU5ErkJggg=='"/>

	<!-- У схем с declarant - сразу всех заявителей 1го уровня У схем с owner - выбираем овнеров у которых нет декларантов, и всех выбираем представителей 1го уровня. -->

	<!-- Заявители -->
	<!--xsl:variable name="dperson" select="//node()/tns:subjects/tns:declarant/subj:person"/>
	<xsl:variable name="dpersonPrevileg" select="//node()/tns:subjects/tns:declarant/subj:previligedPerson"/>
	<xsl:variable name="dorganization" select="//node()/tns:subjects/tns:declarant/subj:organization"/>
	<xsl:variable name="dcountry" select="//node()/tns:subjects/tns:declarant/subj:country"/>
	<xsl:variable name="drfSubject" select="//node()/tns:subjects/tns:declarant/subj:rfSubject"/>
	<xsl:variable name="dother" select="//node()/tns:subjects/tns:declarant/subj:other"/-->



	<!-- Правообладатели-->
	<!--xsl:variable name="operson" select="//node()/tns:subjects/tns:owners/tns:owner/subj:person"/>
	<xsl:variable name="oorganization" select="//node()/tns:subjects/tns:owners/tns:owner/subj:organization"/>
	<xsl:variable name="ocountry" select="//node()/tns:subjects/tns:owners/tns:owner/subj:country"/>
	<xsl:variable name="orfSubject" select="//node()/tns:subjects/tns:owners/tns:owner/subj:rfSubject"/>
	<xsl:variable name="oother" select="//node()/tns:subjects/tns:owners/tns:owner/subj:other"/-->
	<!-- Представители 1го уровня-->
	<!--xsl:variable name="orperson" select="//node()/tns:subjects/tns:owners/tns:owner/subj:representative/subj:subject/subj:person"/>
	<xsl:variable name="orpersonPrevileg" select="//node()/tns:subjects/tns:owners/tns:owner/subj:representative/subj:subject/subj:previligedPerson"/>
	<xsl:variable name="ororganization" select="//node()/tns:subjects/tns:owners/tns:owner/subj:representative/subj:subject/subj:organization"/>
	<xsl:variable name="orcountry" select="//node()/tns:subjects/tns:owners/tns:owner/subj:representative/subj:subject/subj:country"/>
	<xsl:variable name="orrfSubject" select="//node()/tns:subjects/tns:owners/tns:owner/subj:representative/subj:subject/subj:rfSubject"/>
	<xsl:variable name="orother" select="//node()/tns:subjects/tns:owners/tns:owner/subj:representative/subj:subject/subj:other"/-->
	<!-- Представитель 2го уровня. (Предс-ль правообладателя  - ЮЛ1 и представитель этого ЮЛ1 - ФЛ)-->
	<!--xsl:variable name="ororganizationPer" select="//node()/tns:subjects/tns:owners/tns:owner/subj:representative/subj:subject/subj:representative/subj:subject/subj:person"/>
	<xsl:variable name="ororganizationPerPrevileg" select="//node()/tns:subjects/tns:owners/tns:owner/subj:representative/subj:subject/subj:representative/subj:subject/subj:previligedPerson"/-->

	<!--xsl:variable name="signCount" select="(count($dperson)+count($dpersonPrevileg)+count($dorganization)+count($dcountry)+count($drfSubject)+count($dother))"/-->

	<!-- Земельный участок -->
	<xsl:variable name="parcel" select="002001001000"/>
	<!-- Здание -->
	<xsl:variable name="building" select="002001002000"/>
	<!-- Помещение -->
	<xsl:variable name="room" select="002001003000"/>
	<!-- Сооружение -->
	<xsl:variable name="construction" select="002001004000"/>
	<!-- Объект незавершённого строительства -->
	<xsl:variable name="underConstruction" select="002001005000"/>
	<!-- Предприятие как имущественный комплекс (ПИК) -->
	<xsl:variable name="propertyComplex" select="002001006000"/>
	<!-- Единый недвижимый комплекс -->
	<xsl:variable name="realEstateComplex" select="002001008000"/>
	<!-- Машино-место -->
	<xsl:variable name="carPlace" select="002001009000"/>
	<!-- Иной объект недвижимости -->
	<xsl:variable name="other" select="002001010000"/>

	<xsl:variable name="creationDate" select="//tns:header/stCom:creationDate"/>
	<xsl:variable name="specialistNote" select="//tns:deliveryDetails/stCom:requestDeliveryMethod/stCom:specialistNote"/>

	<!-- новые параметры !!
	Тип организации
	Наименование организации
	Номер по книге учёта
	Дата и время регистрации
	Срок оказания услуги
	Пользователь (ФИО)
	Пользователь (должность)
    Текущая дата -->

	<!-- Параметры получаемые извне-->
	<!--xsl:param name="typeOrgan"/-->
	<xsl:param name="typeOrgan" select="'PVD'"/>
	<xsl:param name="nameOrgan"/>
	<xsl:param name="numPPOZ"/>
	<xsl:param name="when"/>
	<!--xsl:param name="when" select="'2016-09-16T10:53:29Z'"/-->
	<xsl:param name="deadlineDays"/>
	<xsl:param name="deadlineDate"/>
	<xsl:param name="userFIO"/>
	<xsl:param name="userPost"/>
	<xsl:param name="dateNow"/>
	<xsl:param name="statInternalNumber"/>
	<xsl:param name="isChargeFree"/>
	<xsl:param name="contactInfo"/>

	<!--Стартовый шаблон для всех видов-->
	<xsl:template match="*">
		<html lang="ru">
			<head>
				<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
				<xsl:comment><![CDATA[[[if lt IE 9]>
					<script>
						var e = ("article,aside,figcaption,figure,footer,header,hgroup,nav,section,time").split(',');
						for (var i = 0; i < e.length; i++) {
							document.createElement(e[i]);
						}
					</script>
				<![endif]]]></xsl:comment>
				<style type="text/css">html{font-family:sans-serif;-ms-text-size-adjust:100%;-webkit-text-size-adjust:100%}body{margin:0}article,aside,details,figcaption,figure,footer,header,hgroup,main,menu,nav,section,summary{display:block}audio,canvas,progress,video{display:inline-block;vertical-align:baseline}audio:not([controls]){display:none;height:0}[hidden],template{display:none}a{background-color:transparent}a:active,a:hover{outline:0}abbr[title]{border-bottom:1px dotted}b,strong{font-weight:700}dfn{font-style:italic}h1{font-size:2em;margin:.67em 0}mark{background:#ff0;color:#000}small{font-size:80%}sub,sup{font-size:75%;line-height:0;position:relative;vertical-align:baseline}sup{top:-.5em}sub{bottom:-.25em}img{border:0}svg:not(:root){overflow:hidden}figure{margin:1em 40px}hr{-moz-box-sizing:content-box;box-sizing:content-box;height:0}pre{overflow:auto}code,kbd,pre,samp{font-family:monospace,monospace;font-size:1em}button,input,optgroup,select,textarea{color:inherit;font:inherit;margin:0}button{overflow:visible}button,select{text-transform:none}button,html input[type="button"],/* 1 */
input[type="reset"],input[type="submit"]{-webkit-appearance:button;cursor:pointer}button[disabled],html input[disabled]{cursor:default}button::-moz-focus-inner,input::-moz-focus-inner{border:0;padding:0}input{line-height:normal}input[type="checkbox"],input[type="radio"]{box-sizing:border-box;padding:0}input[type="number"]::-webkit-inner-spin-button,input[type="number"]::-webkit-outer-spin-button{height:auto}input[type="search"]{-webkit-appearance:textfield;-moz-box-sizing:content-box;-webkit-box-sizing:content-box;box-sizing:content-box}input[type="search"]::-webkit-search-cancel-button,input[type="search"]::-webkit-search-decoration{-webkit-appearance:none}fieldset{border:1px solid silver;margin:0 2px;padding:.35em .625em .75em}legend{border:0;padding:0}textarea{overflow:auto}optgroup{font-weight:700}table{border-collapse:collapse;border-spacing:0}td,th{padding:0}
				</style>
				<!--style type="text/css">body{font-family:times new roman,arial,sans-serif;font-size:100%;line-height:1.42857143;color:#000;background-color:#fff}#wrapper{width:800px;margin:0 auto;overflow:hidden;border:1px solid #000;-webkit-hyphens:auto;-moz-hyphens:auto;-ms-hyphens:auto;hyphens:auto;word-break:break-word;margin-top:30px;margin-bottom:30px}section{border-spacing:1px}.table{display:table;border:0;width:100%;white-space:nowrap;table-layout:fixed}.row{display:table-row}.cell{content:'';overflow-wrap:break-word;word-wrap:break-word;-ms-word-break:break-all;word-break:break-all;word-break:break-word;-ms-hyphens:auto;-moz-hyphens:auto;-webkit-hyphens:auto;hyphens:auto;display:table-cell;border:1px solid #000;padding:2px 8px}.title{padding-left:0;padding-right:0}.title .ul{border-bottom:1px solid #000}.supertitle{padding-left:8px;padding-right:8px;width:360px;font-size:80%}.supertitleabs{position:absolute;top:58px;padding-left:8px;padding-right:8px;height:50px;width:360px;line-height:3.1;font-size:80%}.superaddr{position:absolute;top:310px;padding-left:8px;padding-right:8px;width:727px;line-height:1.63}.book{display:inline-block;#vertical-align:top;#line-height:1.2;font-size:83%}.undertext{display:inline-block;vertical-align:top;line-height:1.4;font-size:64%;top:0}.bookmargin{margin-top:-8px}@media screen and (min-width:0) and (min-resolution: +72dpi){.tablemargin{margin-top:-1px;margin-bottom:-1px;margin-left:-1px;width:calc(100% + 2px)}}.marginleft{margin-left:-1px}.clear{border:0;padding:0}.borders{border:1px solid #000}.noborder{border:0}.leftborder{border-left:1px solid #000}.topborder{border-top:1px solid #000}.bottomborder{border-bottom:1px solid #000}.nopadding{padding:0}.nospacing{border-spacing:0}.lh-normal{line-height:normal}.lh-middle{line-height:1.2}.lh-small{line-height:1}.leftpad{padding-left:8px}.bottompad{padding-bottom:10px}.bottompad5{padding-bottom:5px}.updownpad{padding-top:10px;padding-bottom:10px}.sidepad{padding-left:8px;padding-right:8px;padding-top:8px}.boxpad{padding-left:5px;padding-right:5px}.toppad5{padding-top:5px}.notoppad{padding-top:0}span.box{display:inline-block;width:25px;text-align:center}.wrap{white-space:normal;-webkit-hyphens:manual;-moz-hyphens:manual;-ms-hyphens:manual;hyphens:manual;word-break:normal}.block{display:block}.inline{display:inline}.inlineblock{display:inline-block}.float{float:left}.center{text-align:center}.justify{text-align:justify}.justifylast{text-align:justify;text-align-last:justify;-moz-text-align-last:justify;-webkit-text-align-last:justify}.justifyleft{text-align:justify;text-align-last:left;-moz-text-align-last:left;-webkit-text-align-last:left}.left{text-align:left}.vmiddle{vertical-align:middle}.bold{font-weight:700}.normal{font-weight:400}.mtop2{margin-top:2px}.h1{height:1px\0/!important}.h60{height:60px}.h100{height:100%}.ht{height:calc(100% + 2px)}.w5{width:5px}.w10{width:10px}.w15{width:15px}.w20{width:20px}.w30{width:30px}.w35{width:35px}.w40{width:40px}.w43{width:43px}.w45{width:45px}.w50{width:50px}.w55{width:55px}.w65{width:65px}.w75{width:75px}.w85{width:85px}.w90{width:90px}.w100{width:100px}.w115{width:115px}.w135{width:135px}.w140{width:140px}.w150{width:150px}.w152{width:152px}.w155{width:155px}.w160{width:160px}.w165{width:165px}.w182{width:182px}.w184{width:184px}.w185{width:185px}.w190{width:190px}.w200{width:200px}.w217{width:217px}.w220{width:220px}.w248{width:248px}.w251{width:251px}.w270{width:270px}.w280{width:280px}.w290{width:290px}.w295{width:295px}.w300{width:300px}.w350{width:350px}.w360{width:360px}.w380{width:380px}.w385{width:385px}.w400{width:400px}.w430{width:430px}.w528{width:528px}.w545{width:545px}*,:before,:after{-moz-box-sizing:border-box;-webkit-box-sizing:border-box;box-sizing:border-box}
				</style-->
				<style type="text/css">body{font-family:times new roman, arial, sans-serif;font-size:100%;line-height:1.42857143;color:#000;background:#fff;}#wrapper{width:800px;overflow:hidden;border:1px solid #000;-webkit-hyphens:auto;-moz-hyphens:auto;-ms-hyphens:auto;hyphens:auto;word-break:break-word;margin:30px auto;}#wrapperClear{width:800px;overflow:hidden;-webkit-hyphens:auto;-moz-hyphens:auto;-ms-hyphens:auto;hyphens:auto;word-break:break-word;margin:30px auto;}section{border-spacing:1px;}.table{display:table;border:0;width:100%;white-space:nowrap;table-layout:fixed;}.row{display:table-row;}.cell{content:'';overflow-wrap:break-word;word-wrap:break-word;-ms-word-break:break-all;word-break:break-all;word-break:break-word;-ms-hyphens:auto;-moz-hyphens:auto;-webkit-hyphens:auto;hyphens:auto;display:table-cell;border:1px solid #000;padding:2px 8px;}.title{padding-left:0;padding-right:0;}.supertitle{#position:absolute;#top:58px;padding-left:8px;padding-right:8px;#height:50px;width:360px;#line-height:3.1;font-size:80%;}.supertitleabs{position:absolute;top:58px;padding-left:8px;padding-right:8px;height:50px;width:360px;line-height:3.1;font-size:80%;}.superaddr{position:absolute;top:310px;padding-left:8px;padding-right:8px;width:727px;line-height:1.63;}.book{display:inline-block;#vertical-align:top;#line-height:1.2;font-size:83%;}.undertext{display:inline-block;vertical-align:top;line-height:1.4;font-size:64%;top:0;}.bookmargin{margin-top:-8px;}.tablemargin{margin-top:-1px;margin-bottom:-1px;margin-left:-1px;width:calc(100%+2px);}.marginleft{margin-left:-1px;}.clear{border:0;padding:0;}.borders{border:1px solid #000;}.noborder{border:0;}.leftborder{border-left:1px solid #000;}.topborder{border-top:1px solid #000;}.nopadding{padding:0;}.nospacing{border-spacing:0;}.lh-normal{line-height:normal;}.lh-middle{line-height:1.2;}.lh-small{line-height:1;}.leftpad{padding-left:8px;}.bottompad{padding-bottom:10px;}.bottompad5{padding-bottom:5px;}.updownpad{padding-top:10px;padding-bottom:10px;}.sidepad{padding-left:8px;padding-right:8px;padding-top:8px;}.boxpad{padding-left:5px;padding-right:5px;}.toppad5{padding-top:5px;}.notoppad{padding-top:0;padding-bottom:0;}span.box{display:inline-block;width:25px;text-align:center;}.wrap{white-space:normal;-webkit-hyphens:manual;-moz-hyphens:manual;-ms-hyphens:manual;hyphens:manual;word-break:normal;}.block{display:block;}.inline{display:inline;}.float{float:left;}.center{text-align:center;}.vbottom{vertical-align:bottom;}.justify{text-align:justify;}.justifylast{text-align:justify;text-align-last:justify;-moz-text-align-last:justify;-webkit-text-align-last:justify;}.justifyleft{text-align:justify;text-align-last:left;-moz-text-align-last:left;-webkit-text-align-last:left;}.left{text-align:left;}.right{text-align:right}.vmiddle{vertical-align:middle;}.bold{font-weight:700;}.normal{font-weight:400;}.mtop2{margin-top:2px;}.h1{height:1px!important;}.h60{height:60px;}.h100{height:100%;}.ht{height:calc(100%+2px);}.w5{width:5px;}.w10{width:10px;}.w15{width:15px;}.w20{width:20px;}.w30{width:30px;}.w40{width:40px;}.w43{width:43px;}.w45{width:45px;}.w50{width:50px;}.w52{width:52px;}.w53{width:53px;}.w55{width:55px;}.w65{width:65px;}.w75{width:75px;}.w85{width:85px;}.w90{width:90px;}.w100{width:100px;}.w106{width:106px;}.w107{width:107px;}.w115{width:115px;}.w135{width:135px;}.w140{width:140px;}.w150{width:150px;}.w152{width:152px;}.w155{width:155px;}.w160{width:160px;}.w165{width:165px;}.w182{width:182px;}.w184{width:184px;}.w185{width:185px;}.w190{width:190px;}.w200{width:200px;}.w217{width:217px;}.w220{width:220px;}.w248{width:248px;}.w251{width:251px;}.w260{width:260px;}.w270{width:270px;}.w280{width:280px;}.w290{width:290px;}.w295{width:295px;}.w300{width:300px;}.w350{width:350px;}.w360{width:360px;}.w380{width:380px;}.w385{width:385px;}.w400{width:400px;}.w428{width:428px;}.w430{width:430px;}.w528{width:528px;}.w545{width:545px;}.rotatedBlock{-moz-transform:rotate(-90deg);-webkit-transform:rotate(-90deg);-o-transform:rotate(-90deg);-ms-transform:rotate(-90deg);transform:rotate(-90deg);}*,:before,:after{-moz-box-sizing:border-box;-webkit-box-sizing:border-box;box-sizing:border-box;}.title .ul,.bottomborder{border-bottom:1px solid #000;}</style>
				
				<style type="text/css"></style>
				<!--Стили из файла CSS, потом, если поменяется, выполнить обфускацию и встроить вместо камента выше-->
				<!--link rel="stylesheet" type="text/css" href="css/common.css"/-->
				<xsl:comment><![CDATA[[[if IE 8]><style type="text/css">.tablemargin{width:calc(100% + 2px)}</style><![endif]]]></xsl:comment>
				<xsl:comment><![CDATA[[if !(IE 8)|!(IE)]><style type="text/css">.tablemargin{margin-top:-1px;margin-bottom:-1px;margin-left:-1px;width:calc(100% + 2px)}</style><![endif]]]></xsl:comment>
				<title>Расписка ГКУ/ГРП</title>
			</head>
			<body style="font-family: Times New Roman;">
			<!--body style="font-family: Times New Roman;" onload="window.print()"-->
				<div id="wrapperClear">
					<div class="table">
						<div class="row">
							<div class="cell w530 clear lh-small center">
								<xsl:variable name="appeal">
									<xsl:call-template name="substring-before-last">
										<xsl:with-param name="input" select="//node()/@_id"/>
										<xsl:with-param name="substr" select="'-'"/>
									</xsl:call-template>
								</xsl:variable>	
								<xsl:call-template name="ShowBarcodeImage">
									<xsl:with-param name="imageSrc" select="$appeal"/>
								</xsl:call-template>
							</div>
							<div class="cell right clear lh-small">
								<div style=" font-size: 80%;">
								<!--div style=" font-size: 80%;"-->
									<xsl:value-of select="//node()/@_id"/>
									<xsl:text> от </xsl:text>
									<xsl:call-template name="DateStr">
										<xsl:with-param name="dateStr" select="$creationDate"/>
									</xsl:call-template>
								<!--/div-->	
								</div>
							</div>
						</div>
						<!--div class="row">
							<div class="cell w45 clear">
							</div>
							<div class="cell right clear lh-small">
								<div style=" font-size: 80%;">
									<xsl:value-of select="//node()/@_id"/>
									<xsl:text> от </xsl:text>
									<xsl:call-template name="DateStr">
										<xsl:with-param name="dateStr" select="$creationDate"/>
									</xsl:call-template>
								</div>	
							</div>
						</div-->
						<xsl:if test="$typeOrgan = 'MFC'">	
							<xsl:if test="normalize-space($when) or normalize-space($numPPOZ)">	
								<div class="row">
									<div class="cell w45 clear">
									</div>
									<div class="cell right clear lh-small">
										<div style=" font-size: 80%;">
											<xsl:value-of select="$numPPOZ"/>
											<xsl:text> от </xsl:text>
											<xsl:call-template name="DateStr">
												<xsl:with-param name="dateStr" select="$when"/>
											</xsl:call-template>
											<xsl:text>&nbsp;</xsl:text>
											<xsl:call-template name="TimeHoursStr">
												<xsl:with-param name="dateStr" select="$when"/>
											</xsl:call-template>
											<xsl:text>:</xsl:text>
											<xsl:call-template name="TimeMinutesStr">
												<xsl:with-param name="dateStr" select="$when"/>
											</xsl:call-template>
										</div>
									</div>
								</div>
							</xsl:if>	
						</xsl:if>	
					</div>
					<!--section-->
					<!--div class="boxpad notoppad nospacing"-->
						<xsl:call-template name="point0"/>
						<xsl:call-template name="point1"/>
						<xsl:call-template name="point2"/>
						<xsl:call-template name="point3"/>
					<!--/div-->	
					<!--/section-->
				</div>
			</body>
		</html>
	</xsl:template>
	
	<!--Заголовок-->
	<xsl:template name="point0">
		<xsl:if test="$typeOrgan = 'PVD'">	
			<br/>
			<div class="table">
				<div class="row">
					<div class="cell clear center w50 wrap">
					</div>
					<div class="cell clear center w400 wrap">
						<!--xsl:value-of select="//node()/tns:deliveryDetails/stCom:requestDeliveryMethod/stCom:regRightAuthority"/-->
						<xsl:value-of select="$nameOrgan"/>
					</div>
					<div class="cell clear center w50 wrap">
					</div>
				</div>
			</div>	
			<div class="table">
				<div class="row">
					<div class="cell noborder bold center">
							<div>РАСПИСКА</div>
							<div>в получении документов на государственный кадастровый учет и (или) </div>
							<div>государственную регистрацию прав</div>
					</div>
				</div>
			</div>	
			<div class="table">
				<div class="row">
					<div class="cell clear w165 center wrap bottomborder bold">
						<xsl:call-template name="getActionCode">
							<xsl:with-param name="actionCode" select="//node()/tns:header/stCom:actionCode"/>
						</xsl:call-template>
					</div>
					<div class="cell clear w30 center wrap">
						<xsl:text> на (с) </xsl:text>
					</div>
					<div class="cell center clear w165 wrap bottomborder bold vbottom">
						<xsl:if test="$objects">
							<xsl:for-each select="$objects">
								<xsl:variable name="objectTypeCode" select="obj:objectTypeCode"/>
								<xsl:choose>
									<xsl:when test="$objectTypeCode = $parcel">
										<xsl:text>земельный участок</xsl:text>
									</xsl:when>
									<xsl:when test="$objectTypeCode = $construction">
										<xsl:text>сооружение</xsl:text>
									</xsl:when>
									<xsl:when test="$objectTypeCode = $realEstateComplex">
										<xsl:text>единый недвижимый комплекс</xsl:text>
									</xsl:when>
									<xsl:when test="$objectTypeCode = $building">
										<xsl:text>здание</xsl:text>
									</xsl:when>
									<xsl:when test="$objectTypeCode = $room">
										<xsl:text>помещение</xsl:text>
									</xsl:when>
									<xsl:when test="$objectTypeCode = $underConstruction">
										<xsl:text>объект незавершенного строительства</xsl:text>
									</xsl:when>
									<xsl:when test="$objectTypeCode = $propertyComplex">
										<xsl:text>предприятие как имущественный комплекс</xsl:text>
									</xsl:when>
									<xsl:when test="$objectTypeCode = $carPlace">
										<xsl:text>машино-место</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>иной: </xsl:text>
										<xsl:value-of select="obj:customTypeDesc"/>
									</xsl:otherwise>
								</xsl:choose>
									
								<xsl:if test="position() != count($objects)">
									<xsl:text>, </xsl:text>
								</xsl:if>
							</xsl:for-each>
						</xsl:if>
					</div>
				</div>
			</div>
			<div class="table">
				<div class="row">
					<div class="cell clear w165 center wrap ">
						<div style=" font-size: 80%;">
							<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;(вид учетного и (или) регистрационного действия, о совершении которого подано заявление)&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
						</div>	
					</div>
					<div class="cell clear w30 center wrap ">
					</div>
					<div class="cell clear w165 center wrap ">
						<div style=" font-size: 80%;">
							<xsl:text>(вид объекта недвижимости)</xsl:text>
						</div>	
					</div>
				</div>
			</div>
		</xsl:if>

		<xsl:if test="$typeOrgan = 'MFC'">	
				<br/>
			<div class="table">
				<div class="row">
					<div class="cell clear center w50 wrap">
					</div>
					<div class="cell clear center w400 wrap">
						<xsl:value-of select="$nameOrgan"/>
					</div>
					<div class="cell clear center w50 wrap">
					</div>
				</div>
			</div>	
			<div class="table">
				<div class="row">
					<div class="cell noborder bold center">
							<div>ОПИСЬ</div>
							<div>документов, принятых для оказания государственных услуг</div>
					</div>
				</div>
			</div>	
			<div class="table">
				<div class="row">
					<div class="cell clear center wrap bottomborder bold">
						<xsl:call-template name="getActionCode">
							<xsl:with-param name="actionCode" select="//node()/tns:header/stCom:actionCode"/>
						</xsl:call-template>
					</div>
				</div>
				<div class="row">
					<div class="cell clear center wrap ">
						<div style=" font-size: 80%;">
							<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;(наименование государственной услуги)&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
						</div>	
					</div>
				</div>

				<div class="row">
					<div class="cell center clear center wrap bottomborder bold vbottom">
						<xsl:if test="$objects">
							<xsl:for-each select="$objects">
								<xsl:variable name="objectTypeCode" select="obj:objectTypeCode"/>
								<xsl:choose>
									<xsl:when test="$objectTypeCode = $parcel">
										<xsl:text>земельный участок</xsl:text>
									</xsl:when>
									<xsl:when test="$objectTypeCode = $construction">
										<xsl:text>сооружение</xsl:text>
									</xsl:when>
									<xsl:when test="$objectTypeCode = $realEstateComplex">
										<xsl:text>единый недвижимый комплекс</xsl:text>
									</xsl:when>
									<xsl:when test="$objectTypeCode = $building">
										<xsl:text>здание</xsl:text>
									</xsl:when>
									<xsl:when test="$objectTypeCode = $room">
										<xsl:text>помещение</xsl:text>
									</xsl:when>
									<xsl:when test="$objectTypeCode = $underConstruction">
										<xsl:text>объект незавершенного строительства</xsl:text>
									</xsl:when>
									<xsl:when test="$objectTypeCode = $propertyComplex">
										<xsl:text>предприятие как имущественный комплекс</xsl:text>
									</xsl:when>
									<xsl:when test="$objectTypeCode = $carPlace">
										<xsl:text>машино-место</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>иной: </xsl:text>
										<xsl:value-of select="obj:customTypeDesc"/>
									</xsl:otherwise>
								</xsl:choose>
									
								<xsl:if test="position() != count($objects)">
									<xsl:text>, </xsl:text>
								</xsl:if>
							</xsl:for-each>
						</xsl:if>
					</div>
				</div>
				<div class="row">
					<div class="cell clear center wrap ">
						<div style=" font-size: 80%;">
							<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;(вид объекта недвижимости)&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
						</div>	
					</div>
				</div>
			</div>
		</xsl:if>
		<br/>
		<!-- КН + Адрес -->
		<div class="table">
			<div class="row">
				<div class="cell clear center wrap bottomborder bold">
						<xsl:for-each select="$objects">
							<xsl:if test="string(obj:cadastralNumber/obj:cadastralNumber)">
								<xsl:value-of select="obj:cadastralNumber/obj:cadastralNumber"/>
								<xsl:text>, </xsl:text>
							</xsl:if>	
							<xsl:call-template name="createAddressTemplate">
								<xsl:with-param name="pathToAddress" select="obj:address"/>
							</xsl:call-template>
							<xsl:if test="position() != count($objects)">
								<xsl:text>; </xsl:text>
							</xsl:if>
						</xsl:for-each>
				</div>
			</div>
		</div>
		<div class="table">
			<div class="row">
				<div class="cell clear center wrap ">
					<div style=" font-size: 80%;">
						<xsl:text>(кадастровый номер, адрес (местоположение) объекта недвижимости)</xsl:text>
					</div>	
				</div>
			</div>
		</div>
		<br/>
		<!-- ФИО -->
		<div class="table">
			<div class="row">
				<div class="cell clear center wrap bottomborder bold">
					<xsl:for-each select="//node()/tns:subjects/tns:declarant">
							<xsl:call-template name="showDeclarant">
								<xsl:with-param name="declarantParam" select="node()"/>
								<!--xsl:with-param name="position" select="position()"/-->
							</xsl:call-template>

							<xsl:variable name="curRepresent" select="subj:representative/subj:subject/node()"/>
							<xsl:if test="$curRepresent">
								<xsl:text> (</xsl:text>
								<xsl:call-template name="showDeclarant">
									<xsl:with-param name="declarantParam" select="$curRepresent"/>
								</xsl:call-template>

									<xsl:variable name="curRepresent2" select="subj:representative/subj:subject/subj:representative/subj:subject/node()"/>
									<xsl:if test="$curRepresent2">
										<xsl:text>;&nbsp;</xsl:text>
										<xsl:call-template name="showDeclarant">
											<xsl:with-param name="declarantParam" select="$curRepresent2"/>
										</xsl:call-template>
		
									</xsl:if>	

								<xsl:text>)</xsl:text>
							</xsl:if>	

							<xsl:if test="position() != last()">
								<xsl:text>; </xsl:text>
							</xsl:if>

						<!--xsl:if test="contains(name(), ':person') or contains(name(), ':previligedPerson')">
							<xsl:value-of select="concat(subj:surname, ' ', subj:firstname)"/>
							<xsl:if test="subj:patronymic">
								<xsl:text>&nbsp;</xsl:text>
								<xsl:value-of select="subj:patronymic"/>
							</xsl:if>
						</xsl:if>	
						<xsl:if test="not(contains(name(), ':person') or contains(name(), ':previligedPerson'))">
							<xsl:if test="string(subj:name)">
								<xsl:value-of select="subj:name"/>
							</xsl:if>	
						</xsl:if>	
						<xsl:if test="position() != last()">
							<xsl:text>; </xsl:text>
						</xsl:if-->
					</xsl:for-each>
					
					<!-- схемы с owners  -->
					<xsl:for-each select="//node()/tns:subjects/tns:owners/tns:owner">
							<xsl:call-template name="showDeclarant">
								<xsl:with-param name="declarantParam" select="node()"/>
								<!--xsl:with-param name="position" select="position()"/-->
							</xsl:call-template>

							<xsl:variable name="curRepresent" select="subj:representative/subj:subject/node()"/>
							<xsl:if test="$curRepresent">
								<xsl:text> (</xsl:text>
								<xsl:call-template name="showDeclarant">
									<xsl:with-param name="declarantParam" select="$curRepresent"/>
								</xsl:call-template>

									<xsl:variable name="curRepresent2" select="subj:representative/subj:subject/subj:representative/subj:subject/node()"/>
									<xsl:if test="$curRepresent2">
										<xsl:text>;&nbsp;</xsl:text>
										<xsl:call-template name="showDeclarant">
											<xsl:with-param name="declarantParam" select="$curRepresent2"/>
										</xsl:call-template>
		
									</xsl:if>	

								<xsl:text>)</xsl:text>
							</xsl:if>	
	

							<xsl:if test="position() != last()">
								<xsl:text>; </xsl:text>
							</xsl:if>

						<!--НА БУДУЩЕЕ если будем тянуть представителей. ПРОЕКТ - КОД НЕ ОТЛАЖЕН. Проверяем: если у овнера есть представитель, то выводим его вместо овнера !!!!!!!!!!!!!-->
						<!--xsl:variable name="curRepresent" select="$curPerson/parent::node()/subj:representative"/>
						<xsl:if test="$curRepresent">
							<xsl:call-template name="showDeclarant">
								<xsl:with-param name="declarantParam" select="$curRepresent"/>
								<xsl:with-param name="position" select="position()"/>
							</xsl:call-template>
						</xsl:if>	
						<xsl:if test="not($curRepresent)">
							<xsl:call-template name="showDeclarant">
								<xsl:with-param name="declarantParam" select="$curPerson"/>
								<xsl:with-param name="position" select="position()"/>
							</xsl:call-template>
						</xsl:if-->	

						<!-- СТАРЫЙ КОД, можно убрать со временем xsl:if test="contains(name(), ':person') or contains(name(), ':previligedPerson')">
							<xsl:value-of select="concat(subj:surname, ' ', subj:firstname)"/>
							<xsl:if test="subj:patronymic">
								<xsl:text>&nbsp;</xsl:text>
								<xsl:value-of select="subj:patronymic"/>
							</xsl:if>
							<xsl:if test="position() != last()">
								<xsl:text>; </xsl:text>
							</xsl:if>
						</xsl:if>	
						<xsl:if test="not(contains(name(), ':person') or contains(name(), ':previligedPerson'))">
							<xsl:if test="string(subj:name)">
								<xsl:value-of select="subj:name"/>
							</xsl:if>	
							<xsl:if test="position() != last()">
								<xsl:text>; </xsl:text>
							</xsl:if>
						</xsl:if-->	
					</xsl:for-each>
				</div>
			</div>
		</div>
		<div class="table">
			<div class="row">
				<div class="cell clear center wrap ">
					<div style=" font-size: 80%;">
						<xsl:text>(Ф.И.О., наименование заявителя)</xsl:text>
					</div>	
				</div>
			</div>
		</div>
		<br/>

		<div class="table">
			<div class="row">
				<div class="cell clear left bottom">
					<xsl:text>представлены следующие документы:</xsl:text>
				</div>
			</div>
		</div>

	</xsl:template>

	<xsl:template name="showDeclarant">
		<xsl:param name="declarantParam"/>
		<!--xsl:param name="position"/-->
			<xsl:if test="contains(name($declarantParam), ':person') or contains(name($declarantParam), ':previligedPerson')">
				<xsl:value-of select="concat($declarantParam/subj:surname, ' ', $declarantParam/subj:firstname)"/>
				<xsl:if test="$declarantParam/subj:patronymic">
					<xsl:text>&nbsp;</xsl:text>
					<xsl:value-of select="$declarantParam/subj:patronymic"/>
				</xsl:if>
				<!--xsl:if test="$position != last()">
					<xsl:text>; </xsl:text>
				</xsl:if-->
			</xsl:if>	
			<xsl:if test="not(contains(name($declarantParam), ':person') or contains(name($declarantParam), ':previligedPerson'))">
				<xsl:if test="string($declarantParam/subj:name)">
					<xsl:value-of select="$declarantParam/subj:name"/>
				</xsl:if>	
				<!--xsl:if test="$position != last()">
					<xsl:text>; </xsl:text>
				</xsl:if-->
			</xsl:if>	
	</xsl:template>
	
	<!--Раздел 1-->
	<xsl:template name="point1">
		<!-- Не отображаем документы с типом "Документ удостоверяющий личность" на которого есть ссылки из описания заявителя или правообладателя  Условие слито в общее выражение-->
		<!--xsl:variable name="appDocs" select="//node()/tns:header/stCom:appliedDocument/node()[not((contains(name(), ':idDocument')) and (//@documentID = @_id)) ]"/-->
		<!-- 8.12.2016 #1259 не выводим платежки -->
		<!--Условие для не отображения платёжного документа - равенство значений элементов tns:number и tns:supplierBillId -->
		<!--xsl:variable name="appDocs" select="//node()/tns:header/stCom:appliedDocument/node()[not((contains(name(), ':idDocument')) and (//@documentID = @_id))  and (not(normalize-space(doc:number) = normalize-space(doc:supplierBillId) and normalize-space(doc:number) != '' and normalize-space(doc:supplierBillId) != ''))  ]"/-->

		<!--Устарело - фильтрация конкретного типа документа xsl:variable name="svidelstvo" select="008001011000"/-->
		<!--xsl:variable name="appDocs" select="//node()/tns:header/stCom:appliedDocument/node()[not((contains(name(), ':idDocument')) and (//@documentID = @_id) and doc:documentTypes/node() != $svidelstvo )  and (not(normalize-space(doc:number) = normalize-space(doc:supplierBillId) and normalize-space(doc:number) != '' and normalize-space(doc:supplierBillId) != ''))  ]"/-->

		<!-- 03.05.2017 выльтруем только документы, на которые являются удостоверяющими личность - это ссылка из idDocumentRef -->
		<!--xsl:variable name="appDocs" select="//node()/tns:header/stCom:appliedDocument/node()[not((contains(name(), ':idDocument')) and (//subj:idDocumentRef/@documentID = @_id))  and (not(normalize-space(doc:number) = normalize-space(doc:supplierBillId) and normalize-space(doc:number) != '' and normalize-space(doc:supplierBillId) != ''))  ]"/-->

		<!-- отрезается один тип расписки  -->
		<!--xsl:variable name="appDocs" select="//node()/tns:header/stCom:appliedDocument/node()[not((contains(name(), ':idDocument')) and (//subj:idDocumentRef/@documentID = @_id))  and (not(normalize-space(doc:number) = normalize-space(doc:supplierBillId) and normalize-space(doc:number) != '' and normalize-space(doc:supplierBillId) != ''))  and (doc:documentTypes/node() != '558503000100') ]"/-->

		<!-- 05.05.2017 В расписке не должна отображаться сама расписка в списке документов. фильтруем по кодам из receiptCodes  -->
		<xsl:variable name="appDocs" select="//node()/tns:header/stCom:appliedDocument/node()[not((contains(name(), ':idDocument')) and (//subj:idDocumentRef/@documentID = @_id))  and (not(normalize-space(doc:number) = normalize-space(doc:supplierBillId) and normalize-space(doc:number) != '' and normalize-space(doc:supplierBillId) != '')) and (not(contains($receiptCodes, doc:documentTypes/node())) ) ]"/>

		<!-- Не отображаем документы с типом "Документ удостоверяющий личность" -->
		<xsl:variable name="totalDocs" select="$appDocs [not (contains(doc:documentTypes/node(), '008001'))]"/>


		<!-- Шапка -->
		<!--div class="table tablemargin">
			<div class="row">
				<div class="cell leftpad w40 wrap">№ п/п</div>
				<div class="cell center leftpad w430 wrap">Наименование и реквизиты документов</div>
				<div class="cell clear">
					<div class="table tablemargin">
						<div class="row">
							<div class="table tablemargin">
								<div class="cell center w107 wrap">
									<xsl:text>Количество экземпляров</xsl:text>
								</div>
								<div class="cell center w106 wrap">
									<xsl:text>Количество листов</xsl:text>
								</div>
								<div class="cell center wrap">
									<xsl:text>Отметка о выдаче документов заявителю</xsl:text>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="table tablemargin">
								<div class="cell w50 wrap">
										<br/><br/>
									<span class="marginleft bottompad">
										<br/><br/>
										<div class="table tablemargin">
											<div class="cell noborder wrap rotatedBlock">
												<xsl:text>подлинные</xsl:text>
											</div>										
										</div>										
										<xsl:text>&nbsp;</xsl:text>
									</span>
								</div>
								<div class="cell w50 wrap">
										<br/>
									<span class="marginleft bottompad">
										<br/><br/><br/>
										<div class="table tablemargin">
											<div class="cell noborder wrap rotatedBlock">
												<xsl:text>копии</xsl:text>
											</div>										
										</div>										
										<xsl:text>&nbsp;</xsl:text>
									</span>
								</div>
								<div class="cell w50 wrap">
										<br/><br/>
									<span class="marginleft bottompad">
										<br/><br/><br/>
										<div class="table tablemargin">
											<div class="cell noborder wrap rotatedBlock">
												<xsl:text>в&nbsp;подлинниках</xsl:text>
											</div>										
										</div>										
										<xsl:text>&nbsp;</xsl:text>
									</span>
								</div>
								<div class="cell w50 wrap">
										<br/>
									<span class="marginleft bottompad">
										<br/><br/><br/>
										<div class="table tablemargin">
											<div class="cell noborder wrap rotatedBlock">
											<xsl:text>в&nbsp;копиях&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
											</div>										
										</div>										
										<xsl:text>&nbsp;</xsl:text>
									</span>
								</div>
								<div class="cell w50 wrap">
										<br/>
									<span class="marginleft bottompad">
										<br/><br/><br/>
										<div class="table tablemargin">
											<div class="cell noborder wrap rotatedBlock">
												<xsl:text>подлинные экземпляры</xsl:text>
											</div>										
										</div>										
										<xsl:text>&nbsp;</xsl:text>
									</span>
								</div>
								<div class="cell w50 wrap">
										<br/><br/><br/>
									<span class="marginleft bottompad">
										<div class="table tablemargin">
											<div class="cell noborder wrap rotatedBlock">
												<xsl:text>копии</xsl:text>
											</div>										
										</div>										
										<xsl:text>&nbsp;</xsl:text>
									</span>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div-->

		<div id="wrapperClear">
			<span class="lh-middle notoppad">
			<div class="table">
				<div class="row">
					<div class="cell  w30 wrap noborder topborder leftborder rightborder">&nbsp;&nbsp;&nbsp;№</div>
					<div class="cell center leftpad w360 wrap noborder topborder leftborder rightborder">Наименование и реквизиты документов</div>
					<div class="cell  leftpad w45 noborder topborder leftborder ">&nbsp;&nbsp;&nbsp;&nbsp;Количество</div>
					<div class="cell  leftpad w45 noborder topborder rightborder ">&nbsp;</div>
					<div class="cell  leftpad w45 noborder topborder leftborder">&nbsp;&nbsp;&nbsp;&nbsp;Количество</div>
					<div class="cell  leftpad w45 noborder topborder rightborder">&nbsp;</div>
					<div class="cell  leftpad w45 noborder topborder leftborder ">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Отметка о</div>
					<div class="cell  leftpad w45 noborder topborder rightborder ">&nbsp;</div>
					<div class="cell clear leftborder">&nbsp;</div>
				</div>
				<div class="row">
					<div class="cell w30 wrap noborder leftborder rightborder">&nbsp;п/п</div>
					<div class="cell center leftpad w360 wrap noborder leftborder rightborder">&nbsp;</div>
					<div class="cell  leftpad w45 noborder leftborder ">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;экземпляров</div>
					<div class="cell center leftpad w45 noborder rightborder ">&nbsp;</div>
					<div class="cell  leftpad w45 noborder leftborder ">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;листов</div>
					<div class="cell center leftpad w45 noborder rightborder ">&nbsp;</div>
					<div class="cell  leftpad w45 noborder leftborder ">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;выдаче</div>
					<div class="cell center leftpad w45 noborder  rightborder ">&nbsp;</div>
					<div class="cell clear leftborder">&nbsp;</div>
				</div>
				<div class="row">
					<div class="cell leftpad w30 wrap noborder leftborder rightborder">&nbsp;</div>
					<div class="cell w360 noborder leftborder rightborder">&nbsp;</div>
					<div class="cell center leftpad w45 noborder leftborder ">&nbsp;</div>
					<div class="cell center leftpad w45 noborder rightborder ">&nbsp;</div>
					<div class="cell center leftpad w45 noborder leftborder ">&nbsp;</div>
					<div class="cell center leftpad w45 noborder rightborder ">&nbsp;</div>
					<div class="cell  leftpad w45 noborder leftborder">&nbsp;&nbsp;&nbsp;&nbsp;документов</div>
					<div class="cell center leftpad w45 noborder  rightborder">&nbsp;</div>
					<div class="cell clear leftborder">&nbsp;</div>
				</div>
				<div class="row">
					<div class="cell leftpad w30 wrap noborder leftborder rightborder">&nbsp;</div>
					<div class="cell center leftpad w360 wrap noborder leftborder rightborder">&nbsp;</div>
					<div class="cell center leftpad w45 noborder leftborder ">&nbsp;</div>
					<div class="cell center leftpad w45 noborder rightborder ">&nbsp;</div>
					<div class="cell center leftpad w45 noborder leftborder ">&nbsp;</div>
					<div class="cell center leftpad w45 noborder rightborder ">&nbsp;</div>
					<div class="cell  leftpad w45 noborder leftborder">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;заявителю</div>
					<div class="cell center leftpad w45 noborder  rightborder">&nbsp;</div>
					<div class="cell clear leftborder">&nbsp;</div>
				</div>
			<!--/div>
			<div class="table"-->
				<div class="row">
					<div class="cell leftpad w30 wrap noborder bottomborder leftborder rightborder">&nbsp;</div>
					<div class="cell center leftpad w360 wrap noborder bottomborder leftborder rightborder">
						<xsl:text>&nbsp;</xsl:text>
						<br/>
						<br/>
						<br/>
						<br/>
						<br/>
						<br/>
						<br/>
					</div>
					<div class="cell center leftpad w45 wrap">
						<br/><br/>
						<xsl:call-template name="ShowEmbedImage">
							<xsl:with-param name="imageSrc" select="$col1src"/>
						</xsl:call-template>
					</div>
					<div class="cell center leftpad w45 wrap">
						<br/><br/><br/>
						<xsl:call-template name="ShowEmbedImage">
							<xsl:with-param name="imageSrc" select="$col2src"/>
						</xsl:call-template>
					</div>
					<div class="cell center leftpad w45 wrap">
						<br/>
						<xsl:call-template name="ShowEmbedImage">
							<xsl:with-param name="imageSrc" select="$col3src"/>
						</xsl:call-template>
					</div>
					<div class="cell center leftpad w45 wrap">
						<br/><br/><br/>
						<xsl:call-template name="ShowEmbedImage">
							<xsl:with-param name="imageSrc" select="$col4src"/>
						</xsl:call-template>
					</div>
					<div class="cell center leftpad w45 wrap">
						<br/><br/>
						<xsl:call-template name="ShowEmbedImage">
							<xsl:with-param name="imageSrc" select="$col5src"/>
						</xsl:call-template>
					</div>
					<div class="cell center leftpad w45 wrap">
						<br/><br/><br/>
						<xsl:call-template name="ShowEmbedImage">
							<xsl:with-param name="imageSrc" select="$col2src"/>
						</xsl:call-template>
					</div>
					<div class="cell clear leftborder">&nbsp;</div>
				</div>
			<!--/div-->
				<!-- Данные -->
				<xsl:if test="$totalDocs">
					<!--div class="table"-->
						<!--div class="row"-->
							<xsl:for-each select="$totalDocs">

									<div class="row">
										<div class="cell left w30">
											<!--xsl:number count="*" level="any"/-->
											 <xsl:value-of select="position()"/>
										</div>	
										<div class="cell left wrap w360">
											<xsl:call-template name="showDocumentData">
												<xsl:with-param name="thisDocument" select="."/>
											</xsl:call-template>
										</div>
										<div class="cell center wrap w45">
											<!--xsl:attribute name="style">
												 width:<xsl:value-of select="45"/>px;
											  </xsl:attribute-->
											<xsl:if test="doc:attachment/doc:receivedInPaper/doc:original/doc:docCount">
												<xsl:value-of select="doc:attachment/doc:receivedInPaper/doc:original/doc:docCount"/>
											</xsl:if>
										</div>
										<div class="cell center wrap w45">
											<!--xsl:attribute name="style">
												 width:<xsl:value-of select="45"/>px;
											  </xsl:attribute-->
											<xsl:if test="doc:attachment/doc:receivedInPaper/doc:copy/doc:docCount">
												<xsl:value-of select="doc:attachment/doc:receivedInPaper/doc:copy/doc:docCount"/>
											</xsl:if>
										</div>
										<div class="cell center wrap w45">
											<xsl:if test="doc:attachment/doc:receivedInPaper/doc:original/doc:pageCount">
												<xsl:value-of select="doc:attachment/doc:receivedInPaper/doc:original/doc:pageCount"/>
											</xsl:if>
										</div>
										<div class="cell center wrap w45">
											<xsl:if test="doc:attachment/doc:receivedInPaper/doc:copy/doc:pageCount">
												<xsl:value-of select="doc:attachment/doc:receivedInPaper/doc:copy/doc:pageCount"/>
											</xsl:if>
										</div>
										<div class="cell center wrap w45">
											<xsl:text>&nbsp;</xsl:text>								
										</div>
										<div class="cell center wrap w45">
											<xsl:text>&nbsp;</xsl:text>								
										</div>
										<div class="cell clear leftborder">&nbsp;</div>
									</div>
							</xsl:for-each>
						<!--/div-->
					<!--/div-->
				</xsl:if>
				</div>			
			</span>	
		</div>

	</xsl:template>


	<xsl:template name="point2">
		<xsl:if test="$typeOrgan = 'PVD'">	
		<!--xsl:if test="normalize-space($when) and normalize-space($numPPOZ)"-->	
			<br/>
			<div class="table">
				<div class="row">
					<div class="cell left noborder wrap ">
						<xsl:text>о чем </xsl:text>
						<span class="bold">
							<xsl:call-template name="DateStr">
								<xsl:with-param name="dateStr" select="$when"/>
							</xsl:call-template>
						</span>	
						<xsl:text>&nbsp;в </xsl:text>
						<span class="bold">
							<xsl:call-template name="TimeHoursStr">
								<xsl:with-param name="dateStr" select="$when"/>
							</xsl:call-template>
						</span>
						<xsl:text>&nbsp;час. </xsl:text>
						<span class="bold">
							<xsl:call-template name="TimeMinutesStr">
								<xsl:with-param name="dateStr" select="$when"/>
							</xsl:call-template>
						</span>
						<xsl:text>&nbsp;мин. в книгу учета входящих документов № </xsl:text>
						<span class="bold">
								<xsl:call-template name="substring-before-last">
									<xsl:with-param name="input" select="$numPPOZ"/>
									<xsl:with-param name="substr" select="'-'"/>
								</xsl:call-template>
						</span>
						<xsl:text>&nbsp;внесена запись № </xsl:text>
						<span class="bold">
							<xsl:call-template name="substring-after-last">
								<xsl:with-param name="input" select="$numPPOZ"/>
								<xsl:with-param name="substr" select="'-'"/>
							</xsl:call-template>
						</span>
					</div>
				</div>
			</div>
		</xsl:if>	
		<br/>
		<div class="table">
			<div class="row">
				<div class="cell clear w165 center wrap bottomborder bold">
					<xsl:value-of select="$userPost"/>
				</div>
				<div class="cell clear w30 center wrap">
					<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
				</div>
				<div class="cell clear w165 center wrap bottomborder bold">
					<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
					<xsl:value-of select="$userFIO"/>
				</div>
			</div>	
		</div>	
		<div style=" font-size: 80%;">
			<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(должность сотрудника, принявшего документы)</xsl:text>
			<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
			<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
			<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
			<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(подпись, Ф.И.О.)</xsl:text>
		</div>
		<div class="table">
			<div class="row">
				<div class="cell clear w165 center wrap  bold">
					<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
				</div>
				<div class="cell clear w30 center wrap">
					<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
				</div>
				<div class="cell clear w165 center wrap bottomborder">
					<!--xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text-->
					<xsl:if test="$typeOrgan = 'PVD'">	
						<span class="bold">
							<xsl:call-template name="DateStrFull">
								<xsl:with-param name="dateStr" select="$dateNow"/>
							</xsl:call-template>
						</span>	
					</xsl:if>
					<xsl:if test="$typeOrgan = 'MFC'">	
						<span class="bold">
							<xsl:call-template name="DateStrFull">
								<xsl:with-param name="dateStr" select="$dateNow"/>
							</xsl:call-template>
						</span>	
						<xsl:text>, </xsl:text>
						<span class="bold">
							<xsl:call-template name="TimeHoursStr">
								<xsl:with-param name="dateStr" select="$dateNow"/>
							</xsl:call-template>
						</span>	
						<xsl:text>&nbsp; ч., </xsl:text>
						<span class="bold">
							<xsl:call-template name="TimeMinutesStr">
								<xsl:with-param name="dateStr" select="$dateNow"/>
							</xsl:call-template>
						</span>
						<xsl:text>&nbsp; мин.</xsl:text>
					</xsl:if>
				</div>
			</div>	
		</div>	
		<div style=" font-size: 80%;">
			<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
			<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
			<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
			<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
			<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
			<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
			<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
			<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
			<xsl:if test="$typeOrgan = 'PVD'">	
				<xsl:text>(дата выдачи расписки)</xsl:text>
			</xsl:if>
			<xsl:if test="$typeOrgan = 'MFC'">	
				<xsl:text>(дата и время составления описи)</xsl:text>
			</xsl:if>
		</div>

		<!--div class="table">
			<div class="row">
				<div class="cell clear w165 center wrap  bold">
					<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
				</div>
				<div class="cell clear w30 center wrap">
					<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
				</div>
				<div class="cell clear w165 center wrap bottomborder bold">
					<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
				</div>
			</div>	
		</div-->	


		<div class="table">
			<div class="row">
				<div class="cell clear w165 center wrap  bold">
					<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
				</div>
				<div class="cell clear w30 center wrap">
					<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
				</div>
				<div class="cell clear w165 center wrap bottomborder">
					<!--xsl:if test="$isChargeFree = 'false'"-->	
						<xsl:if test="$deadlineDays">	
							<span class="bold">
								<xsl:value-of select="$deadlineDays"/>
							</span>
							<!--xsl:text>&nbsp;р.д. со дня предоставления заявителем документа об уплате государственной пошлины или получения органом, осуществляющим государственную регистрацию прав, сведений об уплате государственной пошлины</xsl:text-->
							<xsl:text>&nbsp;р.д. с даты приема заявления на осуществление ГКУ и (или) ГРП и прилагаемых к нему документов</xsl:text>
							<xsl:if test="$deadlineDate">
								<br/>плановая дата выдачи <span class="bold"><xsl:value-of select="$deadlineDate"/></span>
							</xsl:if>
						</xsl:if>
						<br/>
					<!--/xsl:if-->	
				</div>
			</div>	
		</div>	
		<div style=" font-size: 80%;">
			<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
			<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
			<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
			<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
			<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
			<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
			<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
			<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
			<xsl:if test="$typeOrgan = 'PVD'">	
				<xsl:text>(дата окончания срока регистрации)</xsl:text>
			</xsl:if>
			<xsl:if test="$typeOrgan = 'MFC'">	
				<!--xsl:text>(дата выдачи (получения) документов)</xsl:text-->
				<xsl:text>(срок оказания государственной услуги)</xsl:text>
			</xsl:if>
		</div>
		
		<!-- РМ-213 Выводим подпись и для описей и для расписок -->
		<xsl:if test="$typeOrgan = 'PVD'">
			<xsl:text>После проведения государственной регистрации документы выданы.</xsl:text>
		</xsl:if>	
		<xsl:if test="$typeOrgan = 'MFC'">
			<xsl:text>После оказания государственной услуги документы выданы.</xsl:text>
		</xsl:if>	
			<br/>
			<br/>
			<xsl:if test="$signCount != 0">
				<xsl:for-each select="//node()/tns:subjects/tns:owners/tns:owner | //node()/tns:subjects/tns:declarant">
					<div class="table">
						<div class="row">
							<div class="cell clear w165 center wrap bottomborder bold">
								<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
							</div>
							<div class="cell clear w30 center wrap">
								<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
							</div>
							<div class="cell clear w165 center wrap bottomborder bold">
								<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
							</div>
						</div>	
					</div>	
					<div style=" font-size: 80%;">
						<xsl:text>&nbsp;(должность, Ф.И.О., подпись сотрудника, выдавшего документы)</xsl:text>
						<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
						<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(Ф.И.О., подпись лица, получившего документы)</xsl:text>
					</div>
				</xsl:for-each>
			</xsl:if>
	
			<br/>
			<div class="table">
				<div class="row">
					<div class="cell clear w165 center wrap  bold">
						<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
					</div>
					<div class="cell clear w30 center wrap">
						<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
					</div>
					<div class="cell clear w165 center wrap bottomborder bold">
						<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
					</div>
				</div>	
			</div>	
			<div style=" font-size: 80%;">
				<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
				<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
				<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
				<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
				<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
				<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
				<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
				<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
				<xsl:text>(дата выдачи (получения) документов)</xsl:text>
			</div>
		<!--/xsl:if-->	
	</xsl:template>

	<xsl:template name="point3">
		<!-- Отметки специалиста -->
		<xsl:if test="normalize-space($specialistNote)">	
			<div class="table">
				<div class="row">
					<div class="cell clear left wrap bottomborder bold">
						<xsl:value-of select="$specialistNote"/>
					</div>
				</div>
			</div>
			<div class="table">
				<div class="row">
					<div class="cell clear center wrap ">
						<div style=" font-size: 80%;">
							<xsl:text>(отметки специалиста)</xsl:text>
						</div>	
					</div>
				</div>
			</div>
		</xsl:if>	
		<!-- Контактная информация -->
		<xsl:if test="normalize-space($contactInfo)">	
			<div class="table">
				<div class="row">
					<div class="cell clear left wrap bottomborder bold">
						<xsl:value-of select="$contactInfo"/>
					</div>
				</div>
			</div>
			<div class="table">
				<div class="row">
					<div class="cell clear center wrap ">
						<div style=" font-size: 80%;">
							<xsl:text>(контактная информация)</xsl:text>
						</div>	
					</div>
				</div>
			</div>
		</xsl:if>	
	
	</xsl:template>

	<!--Вспомогательные процедуры-->

	<xsl:template name="DateStr">
		<xsl:param name="dateStr"/>
		<xsl:if test="string($dateStr)">
			<xsl:value-of select="concat(substring($dateStr, 9,2), '.', substring($dateStr, 6,2), '.', substring($dateStr, 1,4), ' г.')"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="DateStrFull">
		<xsl:param name="dateStr"/>
		<xsl:if test="string($dateStr)">
			<xsl:text>&laquo;</xsl:text>
			<xsl:value-of select="substring($dateStr, 9,2)"/>
			<xsl:text>&raquo;&nbsp;</xsl:text>
			<xsl:choose>
				<xsl:when test="substring($dateStr, 6,2)='01'">января</xsl:when>
				<xsl:when test="substring($dateStr, 6,2)='02'">февраля</xsl:when>
				<xsl:when test="substring($dateStr, 6,2)='03'">марта</xsl:when>
				<xsl:when test="substring($dateStr, 6,2)='04'">апреля</xsl:when>
				<xsl:when test="substring($dateStr, 6,2)='05'">мая</xsl:when>
				<xsl:when test="substring($dateStr, 6,2)='06'">июня</xsl:when>
				<xsl:when test="substring($dateStr, 6,2)='07'">июля</xsl:when>
				<xsl:when test="substring($dateStr, 6,2)='08'">августа</xsl:when>
				<xsl:when test="substring($dateStr, 6,2)='09'">сентября</xsl:when>
				<xsl:when test="substring($dateStr, 6,2)='10'">октября</xsl:when>
				<xsl:when test="substring($dateStr, 6,2)='11'">ноября</xsl:when>
				<xsl:when test="substring($dateStr, 6,2)='12'">декабря</xsl:when>
			</xsl:choose>
			<xsl:text>&nbsp;</xsl:text>
			<xsl:value-of select="substring($dateStr, 1,4)"/>
			<xsl:text> г.</xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template name="TimeHoursStr">
		<xsl:param name="dateStr"/>
		<xsl:if test="string($dateStr)">
			<xsl:value-of select="substring($dateStr, 12,2)"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="TimeMinutesStr">
		<xsl:param name="dateStr"/>
		<xsl:if test="string($dateStr)">
			<xsl:value-of select="substring($dateStr, 15,2)"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="substring-before-last">
		<xsl:param name="input"/>
		<xsl:param name="substr"/>
		<xsl:if test="$substr and contains($input, $substr)">
			<xsl:variable name="temp" select="substring-after($input, $substr)" />
			<xsl:value-of select="substring-before($input, $substr)" />
			<xsl:if test="contains($temp, $substr)">
				<xsl:value-of select="$substr" />
				<xsl:call-template name="substring-before-last">
					<xsl:with-param name="input" select="$temp" />
					<xsl:with-param name="substr" select="$substr" />
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="substring-after-last">
		<xsl:param name="input"/>
		<xsl:param name="substr"/>
		<!-- Выделить строку, следующую за первым вхождением -->
		<xsl:variable name="temp" select="substring-after($input,$substr)"/>
		<xsl:choose>
			<xsl:when test="$substr and contains($temp,$substr)">
				<xsl:call-template name="substring-after-last">
					<xsl:with-param name="input" select="$temp"/>
					<xsl:with-param name="substr" select="$substr"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$temp"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="showDocumentData">
		<xsl:param name="thisDocument"/>
			<!--Для платежного доукмента свой вывод -->
			<xsl:if test="$thisDocument/doc:amount">
				<xsl:if test="$thisDocument/doc:documentTypes/node()">
					<xsl:call-template name="documentTypeTemplate">
						<xsl:with-param name="documentType" select="$thisDocument/doc:documentTypes/node()"/>
					</xsl:call-template>
					<xsl:text>&nbsp;</xsl:text>
				</xsl:if>
				<xsl:if test="$thisDocument/doc:issueDate">
					<xsl:text>от </xsl:text>
					<xsl:call-template name="DateStr">
						<xsl:with-param name="dateStr" select="$thisDocument/doc:issueDate"/>
					</xsl:call-template>
					<xsl:text>&nbsp;</xsl:text>
				</xsl:if>
				<xsl:if test="normalize-space($thisDocument/doc:number)">
					<xsl:text>№</xsl:text>
					<xsl:value-of select="$thisDocument/doc:number"/>
					<xsl:if test="$thisDocument/doc:amount or $thisDocument/doc:payerFullName">&nbsp;</xsl:if>
				</xsl:if>
				<xsl:if test="normalize-space($thisDocument/doc:amount) or normalize-space($thisDocument/doc:payerFullName)">
					<xsl:text>(</xsl:text>
					<xsl:if test="normalize-space($thisDocument/doc:amount)">
						<!--xsl:value-of select="$thisDocument/doc:amount"/-->
						<xsl:apply-templates select="$thisDocument/doc:amount"/>
						<xsl:if test="normalize-space($thisDocument/doc:payerFullName)">
							<xsl:text>, </xsl:text>
						</xsl:if>
					</xsl:if>
					<xsl:if test="normalize-space($thisDocument/doc:payerFullName)">
						<xsl:value-of select="$thisDocument/doc:payerFullName"/>
					</xsl:if>
					<xsl:text>)</xsl:text>
				</xsl:if>
				<!-- Сведения о нотариальном удостоверителе -->
				<xsl:if test="$thisDocument/doc:notaryInfo">
					<xsl:if test="$thisDocument/doc:notaryInfo/doc:registryNumber">
						<xsl:text>, сведения о нотариальном удостоверении: реестровый номер </xsl:text>
						<xsl:value-of select="$thisDocument/doc:notaryInfo/doc:registryNumber"/>
					</xsl:if>
						<xsl:text>, </xsl:text>
						<xsl:call-template name="DateStr">
							<xsl:with-param name="dateStr" select="$thisDocument/doc:notaryInfo/doc:dateOfCertification"/>
						</xsl:call-template>
						<xsl:text>, </xsl:text>
						<xsl:value-of select="$thisDocument/doc:notaryInfo/doc:register/subj:surname"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="$thisDocument/doc:notaryInfo/doc:register/subj:firstname"/>
						<xsl:if test="$thisDocument/doc:notaryInfo/doc:register/subj:patronymic">
							<xsl:text> </xsl:text>
							<xsl:value-of select="$thisDocument/doc:notaryInfo/doc:register/subj:patronymic"/>
						</xsl:if>
				</xsl:if>
			</xsl:if>
			
			<!--Для остальных документов -->
			<xsl:if test="not($thisDocument/doc:amount)">
				<xsl:if test="$thisDocument/doc:name">
					<xsl:value-of select="$thisDocument/doc:name"/>
						<xsl:if test="$thisDocument/doc:issueDate or $thisDocument/doc:number">&nbsp;</xsl:if>
						<xsl:if test="($thisDocument/doc:series or $thisDocument/doc:notes/doc:text or $thisDocument/doc:issuer/doc:name) and not($thisDocument/doc:issueDate or $thisDocument/doc:number) ">, </xsl:if>
				</xsl:if>
				<xsl:if test="not($thisDocument/doc:name)">
					<xsl:if test="$thisDocument/doc:documentTypes/node() or $thisDocument/doc:requestDocumentType">
						<xsl:call-template name="documentTypeTemplate">
							<xsl:with-param name="documentType" select="$thisDocument/doc:documentTypes/node() | $thisDocument/doc:requestDocumentType"/>
						</xsl:call-template>
						<xsl:if test="$thisDocument/doc:issueDate or $thisDocument/doc:number">&nbsp;</xsl:if>
						<xsl:if test="($thisDocument/doc:series or $thisDocument/doc:notes/doc:text or $thisDocument/doc:issuer/doc:name) and not($thisDocument/doc:issueDate or $thisDocument/doc:number) ">, </xsl:if>
					</xsl:if>
				</xsl:if>
				<xsl:if test="$thisDocument/doc:issueDate">
					<xsl:text>от </xsl:text>
					<xsl:call-template name="DateStr">
						<xsl:with-param name="dateStr" select="$thisDocument/doc:issueDate"/>
					</xsl:call-template>
						<xsl:if test="$thisDocument/doc:number">&nbsp;</xsl:if>
						<xsl:if test="($thisDocument/doc:series or $thisDocument/doc:notes/doc:text or $thisDocument/doc:issuer/doc:name) and not($thisDocument/doc:number) ">, </xsl:if>
				</xsl:if>
				<xsl:if test="normalize-space($thisDocument/doc:number)">
					<xsl:text>№</xsl:text>
					<xsl:value-of select="$thisDocument/doc:number"/>
					<xsl:if test="$thisDocument/doc:series or $thisDocument/doc:notes/doc:text or $thisDocument/doc:issuer/doc:name">, </xsl:if>
				</xsl:if>
				<xsl:if test="$thisDocument/doc:series">
					<!--xsl:text>серия: </xsl:text-->
					<xsl:value-of select="$thisDocument/doc:series"/>
					<xsl:if test="$thisDocument/doc:notes/doc:text or $thisDocument/doc:issuer/doc:name">, </xsl:if>
				</xsl:if>
				<xsl:if test="$thisDocument/doc:issuer/doc:name">
					<xsl:value-of select="$thisDocument/doc:issuer/doc:name"/>
					<xsl:if test="$thisDocument/doc:notes/doc:text">, </xsl:if>
				</xsl:if>
				<xsl:if test="$thisDocument/doc:notes/doc:text">
					<xsl:value-of select="$thisDocument/doc:notes/doc:text"/>
				</xsl:if>
				<!-- Сведения о нотариальном удостоверителе -->
				<!--xsl:if test="(local-name($thisDocument) = 'powerOfAttorney')"-->
					<xsl:if test="$thisDocument/doc:notaryInfo">
						<xsl:if test="$thisDocument/doc:notaryInfo/doc:registryNumber">
							<xsl:text>, сведения о нотариальном удостоверении: реестровый номер </xsl:text>
							<xsl:value-of select="$thisDocument/doc:notaryInfo/doc:registryNumber"/>
						</xsl:if>
							<xsl:text>, </xsl:text>
							<xsl:call-template name="DateStr">
								<xsl:with-param name="dateStr" select="$thisDocument/doc:notaryInfo/doc:dateOfCertification"/>
							</xsl:call-template>
							<xsl:text>, </xsl:text>
							<xsl:value-of select="$thisDocument/doc:notaryInfo/doc:register/subj:surname"/>
							<xsl:text> </xsl:text>
							<xsl:value-of select="$thisDocument/doc:notaryInfo/doc:register/subj:firstname"/>
							<xsl:if test="$thisDocument/doc:notaryInfo/doc:register/subj:patronymic">
								<xsl:text> </xsl:text>
								<xsl:value-of select="$thisDocument/doc:notaryInfo/doc:register/subj:patronymic"/>
							</xsl:if>
					</xsl:if>
				<!--/xsl:if-->
			</xsl:if>
	</xsl:template>

	<xsl:template name="documentTypeTemplate">
		<xsl:param name="documentType"/>
		<xsl:variable name="dictPath" select="'Dictionary/DDocument.xsd'" />
		<xsl:variable name="documentTypeEnum" select="document($dictPath)"/>
		<xsl:value-of select="$documentTypeEnum//xs:enumeration[@value=$documentType]/xs:annotation/xs:documentation"/>
	</xsl:template>

	<xsl:template name="getActionCode">
		<xsl:param name="actionCode"/>
		<xsl:variable name="dictPath" select="'Dictionary/DActionCode.xsd'" />
		<xsl:variable name="documentTypeEnum" select="document($dictPath)"/>
		<xsl:value-of select="$documentTypeEnum//xs:enumeration[@value=$actionCode]/xs:annotation/xs:documentation"/>
	</xsl:template>

	<xsl:template name="createAddressTemplate">
		<xsl:param name="pathToAddress"/>
		<!-- Если вызов из ПК ПВД3 (признак - не пустое значение nameOrgan) то логика: или note или остальной адрес -->
		<xsl:if test="$pathToAddress/adr:note">
			<xsl:if test="$nameOrgan">
				<xsl:value-of select="$pathToAddress/adr:note"/> 
			</xsl:if>
        </xsl:if>
		<!-- Адрес не выводим только в случае если вызов из ПК ПВД3 и поле note не пустое. В остальных случаях (для внешних систем) - Адрес и note если есть -->
		<xsl:if test="not(($nameOrgan!='') and ($pathToAddress/adr:note!=''))">
			<!--xsl:value-of select = "$pathToAddress/adr:postalCode"/-->
			<xsl:if test="$pathToAddress/adr:postalCode">
				<xsl:value-of select="$pathToAddress/adr:postalCode"/>, 
			</xsl:if>
			<xsl:if test="string($pathToAddress/adr:region/adr:code)">
				<!--xsl:call-template name="regionCodeTemplate">
					<xsl:with-param name="regionCode" select="$pathToAddress/adr:region/adr:code"/>
				</xsl:call-template-->
				<xsl:value-of select="concat($pathToAddress/adr:region/adr:type, ' ', $pathToAddress/adr:region/adr:name)"/>
				<xsl:if test="$pathToAddress/adr:district or $pathToAddress/adr:city or $pathToAddress/adr:urbanDistrict or $pathToAddress/adr:locality or $pathToAddress/adr:street or $pathToAddress/adr:additionalElement or $pathToAddress/adr:subordinateElement or $pathToAddress/adr:house or $pathToAddress/adr:building or $pathToAddress/adr:structure or $pathToAddress/adr:apartment or $pathToAddress/adr:other">, </xsl:if>
			</xsl:if>
			<xsl:if test="string($pathToAddress/adr:district/adr:name)">
				<xsl:value-of select="$pathToAddress/adr:district/adr:name"/>&nbsp;
				<xsl:value-of select="$pathToAddress/adr:district/adr:type"/>
				<xsl:if test="$pathToAddress/adr:city or $pathToAddress/adr:urbanDistrict or 	$pathToAddress/adr:locality or $pathToAddress/adr:street or $pathToAddress/adr:additionalElement or $pathToAddress/adr:subordinateElement or $pathToAddress/adr:house or $pathToAddress/adr:building or $pathToAddress/adr:structure or $pathToAddress/adr:apartment or $pathToAddress/adr:other">, </xsl:if>
			</xsl:if>
			<xsl:if test="string($pathToAddress/adr:city/adr:name)">
				<xsl:value-of select="$pathToAddress/adr:city/adr:type"/>&nbsp;<xsl:value-of select="$pathToAddress/adr:city/adr:name"/>
				<xsl:if test="$pathToAddress/adr:urbanDistrict or 	$pathToAddress/adr:locality or $pathToAddress/adr:street or $pathToAddress/adr:additionalElement or $pathToAddress/adr:subordinateElement or $pathToAddress/adr:house or $pathToAddress/adr:building or $pathToAddress/adr:structure or $pathToAddress/adr:apartment or $pathToAddress/adr:other">, </xsl:if>
			</xsl:if>
			<xsl:if test="string($pathToAddress/adr:urbanDistrict/adr:name)">
				<xsl:value-of select="$pathToAddress/adr:urbanDistrict/adr:type"/>&nbsp;
				<xsl:value-of select="$pathToAddress/adr:urbanDistrict/adr:name"/>
				<xsl:if test="$pathToAddress/adr:locality or $pathToAddress/adr:street or $pathToAddress/adr:additionalElement or $pathToAddress/adr:subordinateElement or $pathToAddress/adr:house or $pathToAddress/adr:building or $pathToAddress/adr:structure or $pathToAddress/adr:apartment or $pathToAddress/adr:other">, </xsl:if>
			</xsl:if>
			<xsl:if test="string($pathToAddress/adr:locality/adr:name)">
				<xsl:value-of select="$pathToAddress/adr:locality/adr:type"/>&nbsp;<xsl:value-of select="$pathToAddress/adr:locality/adr:name"/>
				<xsl:if test="$pathToAddress/adr:street or $pathToAddress/adr:additionalElement or $pathToAddress/adr:subordinateElement or $pathToAddress/adr:house or $pathToAddress/adr:building or $pathToAddress/adr:structure or $pathToAddress/adr:apartment or $pathToAddress/adr:other">, </xsl:if>
			</xsl:if>
			<xsl:if test="string($pathToAddress/adr:street/adr:name)">
				<xsl:value-of select="$pathToAddress/adr:street/adr:type"/>&nbsp;<xsl:value-of select="$pathToAddress/adr:street/adr:name"/>
				<xsl:if test="$pathToAddress/adr:additionalElement or $pathToAddress/adr:subordinateElement or $pathToAddress/adr:house or $pathToAddress/adr:building or $pathToAddress/adr:structure or $pathToAddress/adr:apartment or $pathToAddress/adr:other">, </xsl:if>
			</xsl:if>
			<xsl:if test="string($pathToAddress/adr:additionalElement/adr:name)">
				<xsl:value-of select="$pathToAddress/adr:additionalElement/adr:type"/>&nbsp;<xsl:value-of select="$pathToAddress/adr:additionalElement/adr:name"/>
				<xsl:if test="$pathToAddress/adr:subordinateElement or $pathToAddress/adr:house or $pathToAddress/adr:building or $pathToAddress/adr:structure or $pathToAddress/adr:apartment or $pathToAddress/adr:other">, </xsl:if>
			</xsl:if>
			<xsl:if test="string($pathToAddress/adr:subordinateElement/adr:name)">
				<xsl:value-of select="$pathToAddress/adr:subordinateElement/adr:type"/>&nbsp;<xsl:value-of select="$pathToAddress/adr:subordinateElement/adr:name"/>
				<xsl:if test="$pathToAddress/adr:house or $pathToAddress/adr:building or $pathToAddress/adr:structure or $pathToAddress/adr:apartment or $pathToAddress/adr:other">, </xsl:if>
			</xsl:if>
			<xsl:if test="string($pathToAddress/adr:house)">
				<xsl:value-of select="$pathToAddress/adr:house/adr:type"/>&nbsp;<xsl:value-of select="$pathToAddress/adr:house/adr:value"/>
				<!--xsl:value-of select="$pathToAddress/adr:house"/-->
				<xsl:if test="$pathToAddress/adr:building or $pathToAddress/adr:structure or $pathToAddress/adr:apartment or $pathToAddress/adr:other">, </xsl:if>
			</xsl:if>
			<xsl:if test="string($pathToAddress/adr:building)">
				<xsl:value-of select="$pathToAddress/adr:building/adr:type"/>&nbsp;<xsl:value-of select="$pathToAddress/adr:building/adr:value"/>
				<xsl:if test="$pathToAddress/adr:structure or $pathToAddress/adr:apartment or $pathToAddress/adr:other">, </xsl:if>
			</xsl:if>
			<xsl:if test="string($pathToAddress/adr:structure)">
				<xsl:value-of select="$pathToAddress/adr:structure/adr:type"/>&nbsp;<xsl:value-of select="$pathToAddress/adr:structure/adr:value"/>
				<xsl:if test="$pathToAddress/adr:apartment or $pathToAddress/adr:other">, </xsl:if>
			</xsl:if>
			<xsl:if test="string($pathToAddress/adr:apartment/adr:name)">
				<xsl:value-of select="$pathToAddress/adr:apartment/adr:type"/>&nbsp;<xsl:value-of select="$pathToAddress/adr:apartment/adr:name"/>
				<xsl:if test="$pathToAddress/adr:other">, </xsl:if>
			</xsl:if>
			<xsl:if test="string($pathToAddress/adr:other)">
				<xsl:value-of select="$pathToAddress/adr:other"/>
			</xsl:if>
			<!-- Неформальное описание с основным адресом выводим если вызов не из ПВД3 (nameOrgan - пустое)  и note не пустое-->
			<xsl:if test="(($nameOrgan='') and ($pathToAddress/adr:note!=''))">
				<xsl:if test="string($pathToAddress/adr:note)">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="$pathToAddress/adr:note"/>
				</xsl:if>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="doc:amount">
		<xsl:variable name="summa" select="." />
		<xsl:variable name="formattedSumma" select="format-number($summa div 100, '0.00')"/>
		<!--xsl:value-of select="$formattedSumma"/-->
		<xsl:if test="contains($formattedSumma, '.')">
			<xsl:value-of select="substring-before($formattedSumma,'.')"/>
			<xsl:text> руб. </xsl:text>
			<xsl:value-of select="substring-after($formattedSumma,'.')"/>
			<xsl:text> коп.</xsl:text>
		</xsl:if>
		<xsl:if test="not(contains($formattedSumma, '.'))">
			<xsl:value-of select="$formattedSumma"/>
			<xsl:text> руб.</xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template name="ShowEmbedImage">
		<xsl:param name="imageSrc"/>
		<xsl:element name="img">
            <xsl:attribute name="src">
                <xsl:value-of select="$imageSrc" />
            </xsl:attribute>
        </xsl:element>
	</xsl:template>

	<xsl:template name="ShowBarcodeImage">
		<xsl:param name="imageSrc"/>
		<xsl:element name="img">
            <xsl:attribute name="src">
                <xsl:value-of select="$imageSrc" />
            </xsl:attribute>
            <xsl:attribute name="type">
				<xsl:text>code128</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="style">
				<xsl:text>height: 0.5cm; width: 8cm</xsl:text>
            </xsl:attribute>
        </xsl:element>
	</xsl:template>

</xsl:stylesheet>
