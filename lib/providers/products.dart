import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import '../utils/constants.dart';
import 'product.dart';

class Products with ChangeNotifier {
  //static String serverUrl =
  //    'shop-app-47fff-default-rtdb.europe-west1.firebasedatabase.app';
  late List<Product> _items = [
    // Product(
    //   id: 'p3',
    //   title: 'Geely Atlas',
    //   description: 'Mmmm nice car.',
    //   price: 30000,
    //   imageUrl:
    //       'https://uc48f248e7ff46e68ca3f61f122a.previews.dropboxusercontent.com/p/thumb/ABbUVgk8jvfOBYGmb1V3GCBXpCPWVT4QHIFvvAqMngKopOg9BN-myp33mp76DgnqrsfbtH99ETl5sh8yNFTZkFA5sBrFn_TBTG0xVDQaB6TukZ5oj78igH8KrS3Ukeb0RHTPfZhrk_vu15u-2iabYVg3G4OW162rB4nluSr-NnpDYPG6_07nYJL15juyLXplFA5_rv7rVlT6raO__uvSmHnSmp-jqLuNmn6_TRnd7GF5Ffwmp8l9iUDxHZKIg_1jMRFJQQlti3JMqhuGw_oiYsJ9zZOiIRvJzkKtGfgyyPH_esbmXqkWJzMzntrHieGvyK71uIhSDz_M-J17uE48_NNu7JmpaIn0-YFIe_sUHLPT2IgzSo26O3TZLNUFJEH0kn0/p.jpeg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 149.99,
    //   imageUrl:
    //       'https://image.shutterstock.com/image-photo/black-fry-pan-over-white-260nw-750875404.jpg',
    // ),
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://ucde8234ae9687dee9efe117c97b.previews.dropboxusercontent.com/p/thumb/ABZlI98yC85kHIwFnPGFqOJ47mXoyKlqpi9AfAHbUOaFSOFNP_ujHl2VuPHRiqxPomhBIoOYORJdmtjahvXgMkAhx5CdsvkQ1E5AzbU9rDxFWrphJkAYC8is4M6_vOEr58QQBttwIENChEeuS_JOFd_TR5XfoosaZi5E5Zp3N_Rg_LNHY8RLowW2Z0iEGJYwhJ_xCRGyXeX8oRdc90YtHQeLBfGBvRgPDeUpnBgj0bqODf0rBe9gW2sh_YFIqxoYH76q5IO_ltLcAq8qDyMBbq-1BeyEIOTFKj6ou5r5zXaAndZEanfg_pC-6zOBCnFOGoHrnzeUweOB5pihPqThZ5eMF7tE4GeORCSRiL3MKiFx0lbcoAwwbgyDrtjJ8cYsSJc/p.jpeg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       //'https://ae01.alicdn.com/kf/HTB1GqIczQCWBuNjy0Faq6xUlXXaj/FQLWL-Sexy-PU-Leather-Pants-Women-Trousers-Black-High-Waist-Pants-Female-Hip-Push-Up-Stretch.jpg',
    //       'https://ucae0a74846a15c3996f35edde4d.previews.dropboxusercontent.com/p/thumb/ABaWT7HGk1Ek0dS61hAWBi1zlec2xxi6ofeDsoPzsP3fjb9gSYRjiHZfADy5z4TKfn78qmXAhjRD_9oFRY4W0ELkFX4neZBb9xSXNlTU3FDjGNl7D3sht5pbpFQMrDhlKPPZgPodryGTolncaAX3SjRnm_Tu2HlFZfB_LOE3fN-FvYyTt3y5-FokvS-EmtQhu9-cy8SLV0NBD8mfFD1a6qoJ1crxpN8-bUhVB4F6NnBZP9Nr2PA4GoHhMEZvSgqRI4TAGQ5RWGXzKwRvxNwfXU7aYiKcubqRhVtqaHTGk16sQ2L4HB2otCjzjd5sJ0QPUqFxd-pW5blFigb9EFczLARWGMF27WbKZr1EheToMD-poe97Pa3zWpBKKur1Qm7tQjU/p.jpeg',
    // ),
    // Product(
    //   id: 'p5',
    //   title: 'Chicken',
    //   description: 'Nice chicken',
    //   price: 8,
    //   imageUrl:
    //       'https://uc9d1d3e6878f3cfe63b0abda642.previews.dropboxusercontent.com/p/thumb/ABYti_ke3RxGJg5liTDNr0youyjAG10jvlBz2PWbhhBPvUx2j3taTnFRIKI6h-h1WWo-zg0vUle5Waoy8BNQWnOzpeU2i6PsobER9PlLWS0vVWmVt8V-myCiz9bZxTj0N3a0jAk7kdEoLwwruYPyL9skZvAPgocf450j8f8DRa77WH8OC08BmCFN_DiASGqhtEjYGuff9mDGdRpyZLvjpikWCa7hPD7Xcvpx3x4573oSx9_EJGO8Cbvr8DEUbUNl6txXImUrvbo82Cgsbh4jWfgMYFc6WnRLIUbcT4EJZPEQ3gRS3V918bg2elNXRvj2DOBbgVcBeY_CdswBofLG_R-VucS_Q9k-zu1Rzci3VI9D7Plo_ssdir-8f7R-LuSgKkE/p.jpeg',
    // ),
    // Product(
    //   id: 'p6',
    //   title: 'Dali',
    //   description: 'Cool one',
    //   price: 57208,
    //   imageUrl:
    //       'https://uc50eff43d5dd78f7de223610c48.previews.dropboxusercontent.com/p/thumb/ABbMigwGQZd-1TPuKWYb3WWyH2uI6QhziTYGsX1W05vsdN4lOle1jA6L1RXpbAHbvN3dBYCp-X7Dk0dBTeNKvsrKi91J--EU7aDwN7GOgZEX16ZFob2flznvFoT8_2wzuCs5cMTw7GlPY0e6_M_MH4tL0I5pg-_Ftm8nTUAOxJf98jDZzUoTyDCEE7-pN3adEDnfDw5Xx1bZ_OcC6eDlxIZrHGBLEDrcGKQgnilfdPgbNCgtBk827bo99xbN-5LIm8SFIVvAchlRfSobhJhSITOpng31AHgLfdqH2r8qtkLhgblGOIV6jTNPAgAkobWor-PH4tyR-Rb3WVIoqJ0nyOJHn42pASOaq8hZSvcIamRTlhaBAr9IlT7GXk7R-F_-_gw/p.jpeg',
    // ),
    // Product(
    //   id: 'p7',
    //   title: 'Hat',
    //   description: 'Simple cowboy hat',
    //   price: 25,
    //   imageUrl:
    //       'https://uc8b25e96f80370e84a83a1163d6.previews.dropboxusercontent.com/p/thumb/ABb-2qPFexIxQPINu6H5iO0gQbr55zvcerHSDimZL1EcusDRcKdtjarCtTXd2FS1ov5NFcj225eLesjdD_IHTIN04jqdGiQlsFC-TenLA2qwxaJboXF3mKJP69mQy192bqz0Yg85kRbiwM0F6Uq4CiFZRJ69s05E0wAdw6CztLYgzfmtRzmJMl0E17WAnnCrH_WWPRTH_ov839hFuYGtRU-Xod6ccjEXOs9wE2jP-pc_BVoS95DMvqpxe2hOdvltibcE69ITOOeHKDF73wfjUth8JC0pR5IP5WKKh9QCgHN4aDOCNQe1DeGNUK_Hf6Kyo4pYWj5z7HB1FsLVDxqXazu8I95Z7i5TNPVM_ZwqU73aIrr5n5b2sc0_GYcS7TAFrPo/p.jpeg',
    // ),
    // Product(
    //   id: 'p8',
    //   title: 'Pink icecream',
    //   description: 'Very tasty',
    //   price: 5,
    //   imageUrl:
    //       'https://uc8cca566f3a490beef914706016.previews.dropboxusercontent.com/p/thumb/ABY6x0h_5S4MxiG961XdaLc--k4jSQf61rQD89V24-QSehw_o5SSrSk7yPyu_736b-B-LdFG8ziLvGcHYGIh_1jgGSN3XoRmWM42LTFBSa651mDpFd_p94x2mbmGAj6_jGnNY7yobj2OLlbk0-4fr3YqMqEOGtRuaKpzCN8K4DollyM39HbehhH1AechQj_5y3j7ODnyKHIUs30b1aI1zpSCiUzz_Zey2MqUo_gGQvM9i_pw2RJF9I47qbnSymb0oSBxXTLwoyqAIa1K8UfEL4ccK6Ugfq07GeKPfnCNTzkbgY6hbTmw6lIaPSr7NWK1pLq9set0E4XIBTxEA6qc2KIn8rmfpE-jxnSq3vNHgMzfRf_5NpIwVMKr1ZTSQWLLqZs/p.jpeg',
    // ),
    // Product(
    //   id: 'p9',
    //   title: 'Plombirus vulgaris',
    //   description: 'Ins konus',
    //   price: 4,
    //   imageUrl:
    //       'https://uc84f59719dbcd7b54fdace5b2f9.previews.dropboxusercontent.com/p/thumb/ABabWksSoLUzpZzdQx48MEFSdkx8jt-hLpOWoiMImoFwI_zxw36JwOQGmZCgzV9y2xFDKnyQKngvRDI83sxYAgFxsoZK6Y6TVJmRzS0lNnf39MDudJK8XhSzrI2JZNWutdbo1Y3_74LGguyRbPXt_6Knoj2nDqiV1gVXVMPJJWElLAK9GO-87-9c9Oeg5URZnyB39QaeFJHwJUeAbXphXsvtirjLhEvC9gFbDEFb4SI0e83Sutjo9h4NYBzbf69zwUmAgCI0FM3ovErOzpEUoZ0K_uWukQGVfcY7lmTtDqzt0_xCmdh4-UJcUh5ZC-3rgOcIyTlZymnk2I0u0rWaZx77fiF5oMenBV3BhAcWwLZxXuYpatCWd-beG_TP1M4Q-oY/p.jpeg',
    // ),
    // Product(
    //   id: 'p11',
    //   title: 'Icecreams pack',
    //   description: 'Cool threesome',
    //   price: 12,
    //   imageUrl:
    //       'https://ucc58c12a3fc3f8fb93f140de247.previews.dropboxusercontent.com/p/thumb/ABYTaiMWxtSileOSHKn4n-EnHgDflLdFDER8VqDCM6C5gHU6AHSqCfETGSU-M7S3ESPMZxKmwj_SEaWmoa3z6c2GcX6lczIiQi-v5sV_z2Co_wodxOzwF3Viq4qJrEu-bi7e9MmHeEzoAmWFLaKm44QbcQ9Tig4adBaOZvz2ES2EzZMpBzCGH8WCheDT9zKz8W-3u46JZ57_l5trqJcw6NDvgJZcG5vGHGfHcZmPDrpZ3qjTfCIUeNEFp7dGjXkW6IvriPGsICy1K8cI142RFOlfwPsfv5arlqxu8DCC-5v5_08kbAWclAJa1C77Z6IiVeV6aMAmziF0NkoyU1asMZTn3hvDmDgJfRnUOPewLPQs4JRf40b5Yzlr8P-3dQj9S_I/p.jpeg',
    // ),
    // Product(
    //   id: 'p12',
    //   title: 'Laptop',
    //   description: 'Looks HP',
    //   price: 500,
    //   imageUrl:
    //       'https://ucca8ecf352c88f1b8edf50a97e0.previews.dropboxusercontent.com/p/thumb/ABZSdHlI-c-neRFp_8vrOSPA19qoDKDP_aip1ndatqB1HzKKxiO436c5h6tv8PhmyRJMgWQ5W8hkTLJyF88tw8qYF4wLXGkw6oIntK3fdKxy1zL0JR7e7jtJoBUYDwvlIQ103EhSH8v3kZiL1zlOi5vSYmB0pwK7qwxUabVdc0_sS-L3FXN6zErJ-Itm3S8Ld5Aq5H5yyg_4xCbKxb3cry2TsUvgbKXjDELKICENiFyFx1kqX9Mf0Tq60yyOvMUuy6JL6EMLMNX-fGbRlSiDA2UakrhKy_DayQ_zVXFXiwOqXzIY2CXHGG_f77OdSOaV-NGqZRhjTGm05EonxCbIvnrZA0ATT1cz9P9i39dSwbDAduGVQAgqA63kxb3T0zTHQe4/p.jpeg',
    // ),
    // Product(
    //   id: 'p13',
    //   title: 'Necron Overlord',
    //   description: 'Not just protects - resurrects!',
    //   price: 35,
    //   imageUrl:
    //       'https://ucaa13c56a49a9d3986076e64602.previews.dropboxusercontent.com/p/thumb/ABagp8mBfUyIu_QLqqZIQiVPcPes7RXk7ZW_LoR-cnPwtAVMOE-VSWSm1c3OHncCbUaEGcdeQwdxfiD-2eZvKCVgZkWm5Yv0L508erfjwZVINPTMuepggyM6AWXQDd8bHGYS18U3oI68ASf8dv-8KI1wMQbMAsrSTkd6DD-D_X9O3DeP4yCVBGyUXeaBwl0BDBU67Brs-ZZ9AESjCnstCxOyGfEn46pn1m5f8N0b-nnh_jsfMqRmUd3YFYQnXI5sGkdvwKxKwHudNa4mv8PIF5YIQKcBe8e2W3LDouEkPNG2ss-XaUWDYNnkmIICyooH4c0iKr5k7TQs6vn72KXzm5zxzW5FKGyiRYdzvgQuVKiRg5OenXtaILxzjZRAW7bfhSQ/p.jpeg',
    // ),
    // Product(
    //   id: 'p14',
    //   title: 'Picasso',
    //   description: 'Girl in mirror',
    //   price: 35600,
    //   imageUrl:
    //       'https://uc3954b78fac19e50cfeaec141dc.previews.dropboxusercontent.com/p/thumb/ABbrLuz0MywqGNrMKev_i7pTeNWJVLNBxjLPt1YjJAX4D1n4Wx-XAmatQuXu8FOqlJNG01diTj-NIfulSuvw7q8DHRgzU6DRj7RlLb2S5QjzaKsQnmrsHXxgUEUnw0tU8Gqk1lXiOSBvZSQLHuL-zuqvuoxzb68odlt-EPxqR9ld1C3EZEd8k75KHffmb-2PkX0cxsfIFSF8NaCe1OlDKn3m3GlIhNi07UmOw2t1fY4OOsRtNvmROpmVr6dDFHhGZj7mztrrRr51QGQ8rzdZdyIKxvxDGxdmHQNn2Ke-bfUX4ZNSSTvaoMeDCyuAStPwNRLVIUYUC06Fa11dba0-yG8mmaoA4To1-K2sYDOUHAtuo9odt16u26KkCAjSPiqpbaU/p.jpeg',
    // ),
    // Product(
    //   id: 'p15',
    //   title: 'Smiling?',
    //   description: 'That smile is costless.',
    //   price: 9999999,
    //   imageUrl:
    //       'https://ucdbc76d6d1e5e418569a8c0540c.previews.dropboxusercontent.com/p/thumb/ABbO5XIn2Ud0yWON2n6XrzuJ5sQW_lsmeSw_PsB9czucQpvCABivyFretHxX_I2QvBBExFvLhXqRSDdW4gZvfW75B-q4v1HqZv7wHiQ9lNhu9qyeYoPtFvWjwg1FcnVvn-CPbYNSSckVay71AdkSAULLaGghcCBjgxyYwv0_cCcVov49AXQ3A8w32O3jKdsWmB8AhexUNoY_5KJV-XEYo9Qa6ZlhIzN3beXUoctphqDfMUbLPA7N_pTx0A4V3gj317ZGfTmUmhwhmV7LlvEtXXuhRmiR4ri8NXXY-8P7kxERcnM-pw2fSQ163FH94nXec94IVTtcvQMDakXs6LBJA-rmiJ3aQ8T_mAZSz76UNHpkOIaE-C9t5s_6Z29PiYu14GE/p.jpeg',
    // ),
    // Product(
    //   id: 'p16',
    //   title: 'Smelling?',
    //   description:
    //       'Mmm smell of bullets making holes in enemies... Again costless.',
    //   price: 9999999,
    //   imageUrl:
    //       'https://uc5ee915da8ffab06e8a110a4123.previews.dropboxusercontent.com/p/thumb/ABZXwHkQTWdk3BJp0fC271HnXgbW3enQCLoRSZjwe2b8ARG3bwyT93ieu6c1dGo3QQmLdJMKANCncWVEIrnQEwN0pCVT4k7DKn8d1sceOtqAMj5f7np4I6GE-y2GyU9Dx5ZelKdRwTjeAM3xrR97WHDzAWC1AFQ9h2lII-xoUs89Q9ClLrliBBMLnBEDfNVKTmPBdjJk0zYpDi1QhQuprF47dpFTYrVBtbdL-HD6E_o2HcZkiO-MOcbFreAJrgL0mBoCL_4voIb4j3SRIkuifvsc6hj2_YmRexBuvfkk_nTGuhN4VsdjaKqh8kFW6Ri2A81KoClLuNs-kcHLg4MeXCeH0V0xr6tscaZVmMDxX9Z0SvlRzKR_QxgxmSKCJ7CI484/p.jpeg',
    // ),
    // Product(
    //   id: 'p17',
    //   title: 'Krutite baraban',
    //   description: 'It`s ideal, sharing idea for free',
    //   price: 0,
    //   imageUrl:
    //       'https://uc44ed82cd8f4a378e022fc67cf4.previews.dropboxusercontent.com/p/thumb/ABY4u6yxiYtBrlZXZPHPsEZLyg3IfVJqRVC46-L3N1kf8Me589d4ySebs-gN0UxIPSUo2lGkZ94xgjnQyhp2dQ7LWxNLCkT_th1jbdfUMaWpo1mW77x5IuD665_3-LmI10ySN_lT2BMpO_1O4sY_VnbnogGMfq_vqPuoZTisiVf0l7r2AHZtXSDoRX40o2ZlOv0vnFPIwqhdnQjEqHjRAAhCBidMcxZeb4HckDjnkhQSmdDZssiGGM7VhNV0UqAojQrldxoI_JBQZu8P69pFByBEHOWvg1uiLofrHtaJsaJxpPxwZqddrWgsdV6WgMKxJTHnHg7pjB6r6TNXmKTRQ1WqQtqbw1arTn5jdA2dE1ruSxWJvRWIY_zGD6NWG-jtOSY/p.jpeg',
    // ),
    // Product(
    //   id: 'p18',
    //   title: 'It`s too late sometimes...',
    //   description: '...wh40k is awesome...',
    //   price: 25,
    //   imageUrl:
    //       'https://uc158bea52f37e933ff5cd38b44b.previews.dropboxusercontent.com/p/thumb/ABanUVxHa4Wbvunvr-0lEduoSqcLRzXOvLNXbwEhxXkc7Q4k87DrcP1JfMVFDv2mahyq9_Yc52nd2e0A9k87KixtFBEyFz9ki6h-bkvUuvdBsMv-LsPAmr7RTUfyo0uNv8pPEYnrjhmFqXmamBrSNGiIvoLX7LyJhlgVolxq7RZ7AYGKoiHRkfgUH8LYtjCdTgpCICsRHI1MgBaZd8PHIWL2JuV4YjLgdb-uihkmjjLhxlBOQqMnK8nNBMXX06Fj6Z9PjDJew3j3kQvSBTO0FiYTMT3L4aprzwZspQJAjcAVpFDHQ_p6PwDstXo-9C7WRRaJqet5jwbzLALvTH5BfEqwBpDXqREUItChVm-fQbtV-4hfGxKgtNbJSyeFvTTtmAM/p.jpeg',
    // ),
    // Product(
    //   id: 'p19',
    //   title: 'Knight and space spider',
    //   description: 'Usual thing nowadays',
    //   price: 150,
    //   imageUrl:
    //       'https://uc68dcd706575a873f9f1928cbda.previews.dropboxusercontent.com/p/thumb/ABak0XOL4t_DsvP8_EcgFIukKfvScAwGMGeh17dicbtbQCL-BV-6lJ9ZD9JOTeSW3UkGrkkhXsrtQ4SmexHyv6arIA1oPl2I98EIeEaNiH82Pmtq0g98FThvpnMzh_6PjE6uP-yJzMbEfcL2pbM0TAipXbUGy4VeEMIyY4uVh5v2B3-dLZmzLfEqlEbgV3Q73bFpwPirxcSDNKLwvW4qEI1Zi_kb3OAjPMoO9O5wP6czlfrT6WO5QnUILD7eHuq7jwU-V8_qCNYT2zptpRYeWc8fYEP8N2pkLcGCZX6Pwo2uOmCI7gXfP1KPfC1LbBhsjCuXoPq9rXwcEJsKwFI10OoeHOZtAHOLdkRh4pnAIzgkfln_HIJpZdu_2szxOwNO7dE/p.jpeg',
    // ),
    // Product(
    //   id: 'p20',
    //   title: 'Logo',
    //   description: 'Just logo',
    //   price: 5,
    //   imageUrl:
    //       'https://uce4b872874521cc67aad04a457a.previews.dropboxusercontent.com/p/thumb/ABZezGBwf7qI6Ix0FZ2zzGrmuhhWTBMlxVCLpQAVZ6HfFYrLxtloBeQ4D_NEllF0uUcn33ZYHPbv_Yx941xZyzQsbn3BOWmcJx5KdLoeYfTxbL1kqNBrgMUjzlL32AGuxGjCpmHpU2E7TPVJpBDe2GgE0vXmXNvl1oK4y6I4uGUksZ8VCbf-5zX4LAKLu_2-oyeiSe_JdZFht4EnS9nNqXdzyl7LV_um-0bta0ly5RBmGOyGXcPcV87wPEHY4Tk0c49JNvHIY_7BT9mOYuUJjKTy6hpgi0m2rEsC5njsWVqTzmr_zpWC-7ulrKaEokC7g8dwcxqq5ntCUQlNPkN9ehQHIfCrKYaMlUU7DeZQEW7Q4wfcvsRY3XUavLLRZ5I_IZU/p.jpeg',
    // ),
  ];

  //var _showFavoritesOnly = false;

  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite == true).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser == true ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    Uri url = Uri.parse(
      'https://$serverUrl/products.json?auth=$authToken&$filterString',
      //'https://$serverUrl/products.json?auth=$authToken',
    );
    // OR
    // https - looks more elegant - BUT ISSUE WITH authToken - NOT WORKING
    // USING Uri.parse instead of Uri.https
    // final url = Uri.https(serverUrl, '/products.json?auth=$authToken');

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null || extractedData == 'not found') {
        return;
      }

      url = Uri.parse(
          'https://$serverUrl/userFavorites/$userId.json?auth=$authToken');
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);

      final List<Product> loadedProducts = [];
      extractedData.forEach(
        (prodId, prodData) {
          loadedProducts.add(
            Product(
              id: prodId,
              title: prodData['title'],
              price: prodData['price'],
              imageUrl: prodData['imageUrl'],
              description: prodData['description'],
              isFavorite: favoriteData is Null
                  ? false
                  : (favoriteData[prodId] is Null
                      ? false
                      : favoriteData[prodId]),
            ),
          );
        },
      );
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    //final url = Uri.https(serverUrl, '/products.json');
    final url = Uri.parse('https://$serverUrl/products.json?auth=$authToken');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': userId,
          },
        ),
      );
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct); // at the end of the list
      //_items.insert(0, newProduct); // at beginning of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      //final url = Uri.https(serverUrl, '/products/$id.json');
      final url =
          Uri.parse('https://$serverUrl/products/$id.json?auth=$authToken');
      try {
        await http.patch(url,
            body: json.encode({
              'title': newProduct.title,
              'description': newProduct.description,
              'imageUrl': newProduct.imageUrl,
              'price': newProduct.price,
              'creatorId': userId,
            }));
        _items[prodIndex] = newProduct;
        notifyListeners();
      } catch (error) {
        rethrow;
      }
    } else {}
  }

  Future<void> deleteProduct(String id) async {
    //final url = Uri.https(serverUrl, '/products/$id.json');
    final url =
        Uri.parse('https://$serverUrl/products/$id.json?auth=$authToken');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Issue while deleting product');
    }
    existingProduct = null;
  }

// void showFavoritesOnly() {
//   _showFavoritesOnly = true;
//   notifyListeners();
// }
//
// void showAll() {
//   _showFavoritesOnly = false;
//   notifyListeners();
// }
}
