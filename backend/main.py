import mysql.connector
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List
from fastapi import Query
from pydantic import BaseModel

app = FastAPI(title="Pharmacy App API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

def get_db_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
        database="pharmacy_app_db",
        charset='utf8mb4',
        collation='utf8mb4_turkish_ci'
    )

# 1. Modeller
class LoginRequest(BaseModel):
    email: str
    password: str

# Kayıt isteği için gelen verileri karşılayan model
class RegisterRequest(BaseModel):
    tckn: int
    name: str
    email: str
    password: str
class OrderItemModel(BaseModel):
    product_id: int
    quantity: int

class OrderRequest(BaseModel):
    user_id: str          # hasta_tckn karşılığı
    eczane_id: int        # Hangi eczaneden alındığı
    total_amount: float
    items: List[OrderItemModel]
class PharmacyLoginRequest(BaseModel):
    email: str
    sifre: str
class ToggleFavoriteRequest(BaseModel):
    user_id: str
    item_id: str
class PharmacyRegisterRequest(BaseModel):
    eczane_ad: str
    eczaci_ad_soyad: str
    eczaci_diploma_no: int
    email: str
    sifre: str
    telefon: str
    adres: str
    latitude: float
    longitude: float
# 2. Ürünleri Çeken Endpoint
@app.get("/products")
def get_products(page: int = 1, limit: int = 10, search: str | None = None):
    conn = None
    cursor = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        offset = (page - 1) * limit

        if search:
            query = """
                SELECT CAST(ilac_id AS CHAR) AS id, ilac_ad AS name, satis_fiyat AS price, stok AS stock, description AS imageUrl, description 
                FROM ilac 
                WHERE ilac_ad LIKE %s 
                LIMIT %s OFFSET %s
            """
            cursor.execute(query, (f"{search}%", limit, offset))
        else:
            query = """
                SELECT CAST(ilac_id AS CHAR) AS id, ilac_ad AS name, satis_fiyat AS price, stok AS stock, description AS imageUrl, description 
                FROM ilac 
                LIMIT %s OFFSET %s
            """
            cursor.execute(query, (limit, offset))

        results = cursor.fetchall()
        return {"success": True, "result": results}

    except Exception as e:
        return {"success": False, "message": str(e)}
    finally:
        if cursor: cursor.close()
        if conn: conn.close()

# 3. Ürün Detay
@app.get("/products/{product_id}")
def get_product_detail(product_id: int):
    conn = None
    cursor = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        query = """
            SELECT CAST(ilac_id AS CHAR) AS id, ilac_ad AS name, satis_fiyat AS price, stok AS stock, description AS imageUrl, description 
            FROM ilac 
            WHERE ilac_id = %s
        """
        cursor.execute(query, (product_id,))
        product = cursor.fetchone()

        if product:
            return {"success": True, "result": product}
        else:
            return {"success": False, "message": "Ürün bulunamadı."}
    except Exception as e:
        return {"success": False, "message": str(e)}
    finally:
        if cursor: cursor.close()
        if conn: conn.close()

@app.get("/products/{product_id}/pharmacies")
def get_pharmacies_with_product(product_id: int):
    conn = None
    cursor = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        query = """
            SELECT 
                e.eczane_id AS id, 
                e.eczane_ad AS name, 
                e.telefon AS phone, 
                e.latitude, 
                e.longitude, 
                'Merkez / İlçe' AS address,
                ei.stok_miktari AS stock
            FROM eczane e
            JOIN eczane_ilac ei ON e.eczane_id = ei.eczane_id
            WHERE ei.ilac_id = %s AND ei.stok_miktari > 0
        """
        cursor.execute(query, (product_id,))
        results = cursor.fetchall()

        return {"success": True, "result": results}
    except Exception as e:
        return {"success": False, "message": str(e)}
    finally:
        if cursor: cursor.close()
        if conn: conn.close()

# 4. Eczaneler


@app.post("/pharmacy/login")
def pharmacy_login(request: PharmacyLoginRequest):
    conn = None
    cursor = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        query = """
            SELECT eczane_id, eczane_ad, email 
            FROM eczane 
            WHERE email = %s AND sifre = %s
        """
        cursor.execute(query, (request.email, request.sifre))
        pharmacy = cursor.fetchone()

        if pharmacy:
            return {
                "success": True,
                "message": "Giriş başarılı",
                "pharmacy": pharmacy
            }
        else:
            return {
                "success": False,
                "message": "E-posta veya şifre hatalı."
            }
    except Exception as e:
        return {"success": False, "message": str(e)}
    finally:
        if cursor: cursor.close()
        if conn: conn.close()


@app.post("/register")
def register_patient(request: RegisterRequest):
    conn = None
    cursor = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        # Hasta tablosuna adres_id değeri verilmeden (NULL) kayıt ekleniyor
        query = """
            INSERT INTO hasta (hasta_tckn, hasta_ad_soyad, email, password, adres_id) 
            VALUES (%s, %s, %s, %s, NULL)
        """
        cursor.execute(query, (request.tckn, request.name, request.email, request.password))
        conn.commit()

        return {"success": True, "message": "Kayıt başarıyla oluşturuldu."}
    except Exception as e:
        if conn: conn.rollback()
        return {"success": False, "message": str(e)}
    finally:
        if cursor: cursor.close()
        if conn: conn.close()
@app.get("/pharmacies")
def get_pharmacies():
    conn = None
    cursor = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        query = """
            SELECT 
                CAST(e.eczane_id AS CHAR) AS id, 
                e.eczane_ad AS name, 
                e.telefon AS phone, 
                e.latitude, 
                e.longitude, 
                1 AS isOpenOnDuty, 
                CONCAT(a.il, ' / ', a.ilce) AS address 
            FROM eczane e
            LEFT JOIN adres a ON e.adres_id = a.adres_id
        """
        cursor.execute(query)
        results = cursor.fetchall()
        return {"success": True, "result": results}
    except Exception as e:
        return {"success": False, "message": str(e)}
    finally:
        if cursor: cursor.close()
        if conn: conn.close()
# 10. İle ve İlçeye Göre Tüm Eczaneleri Listeleme Endpoint'i
# Türkçe ve İngilizce karakter uyumsuzluğunu çözen yardımcı fonksiyon
def fix_turkish_chars(text: str) -> str:
    if not text:
        return ""
    # İngilizce 'i' veya büyük 'I' harflerini Türkçe karşılıklarına esnek uyarlıyoruz
    # veya veritabanındaki orijinal haline benzetiyoruz
    return text.replace('i', 'ı').replace('İ', 'I')
@app.post("/pharmacy/register")
def register_pharmacy(request: PharmacyRegisterRequest):
    conn = None
    cursor = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        # Önce adres tablosuna veya direkt eczane tablosuna ekleme yapabilirsiniz.
        # Projenizin veritabanı yapısına göre adres tablosu zorunluysa önce adres eklenip adres_id alınabilir.
        # Burada doğrudan tablonuza uygun INSERT sorgusunu yazıyoruz:

        query = """
            INSERT INTO eczane (
                eczane_ad, 
                eczaci_ad_soyad, 
                eczaci_diploma_no, 
                telefon, 
                latitude, 
                longitude, 
                email, 
                sifre
            ) 
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        """

        cursor.execute(
            query,
            (
                request.eczane_ad,
                request.eczaci_ad_soyad,
                request.eczaci_diploma_no,
                request.telefon,
                request.latitude,
                request.longitude,
                request.email,
                request.sifre
            )
        )

        conn.commit()

        return {
            "success": True,
            "message": "Eczane kaydı başarıyla oluşturuldu."
        }

    except Exception as e:
        if conn:
            conn.rollback()
        return {
            "success": False,
            "message": str(e)
        }

    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()

@app.get("/pharmacies/city")
def get_all_pharmacies_by_city(city: str, district: str = ""):
    # Gelen değerleri normalize ediyoruz
    fixed_city = f"%{fix_turkish_chars(city)}%"
    fixed_district = f"%{fix_turkish_chars(district)}%" if district else ""

    conn = None
    cursor = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        if district:
            query = """
                SELECT 
                    CAST(e.eczane_id AS CHAR) AS id, 
                    e.eczane_ad AS name, 
                    e.telefon AS phone, 
                    e.latitude, 
                    e.longitude, 
                    CONCAT(a.il, ' / ', a.ilce) AS address,
                    0 AS isOpenOnDuty
                FROM eczane e
                JOIN adres a ON e.adres_id = a.adres_id
                WHERE (a.il LIKE %s OR REPLACE(REPLACE(a.il, 'i', 'ı'), 'İ', 'I') LIKE %s)
                  AND (a.ilce LIKE %s OR REPLACE(REPLACE(a.ilce, 'i', 'ı'), 'İ', 'I') LIKE %s)
            """
            cursor.execute(query, (fixed_city, fixed_city, fixed_district, fixed_district))
        else:
            query = """
                SELECT 
                    CAST(e.eczane_id AS CHAR) AS id, 
                    e.eczane_ad AS name, 
                    e.telefon AS phone, 
                    e.latitude, 
                    e.longitude, 
                    CONCAT(a.il, ' / ', a.ilce) AS address,
                    0 AS isOpenOnDuty
                FROM eczane e
                JOIN adres a ON e.adres_id = a.adres_id
                WHERE (a.il LIKE %s OR REPLACE(REPLACE(a.il, 'i', 'ı'), 'İ', 'I') LIKE %s)
            """
            cursor.execute(query, (fixed_city, fixed_city))

        results = cursor.fetchall()
        return {"success": True, "result": results}
    except Exception as e:
        return {"success": False, "message": str(e)}
    finally:
        if cursor: cursor.close()
        if conn: conn.close()


# 11. İle ve İlçeye Göre Nöbetçi Eczaneleri Listeleme Endpoint'i
@app.get("/pharmacies/duty")
def get_duty_pharmacies(city: str, district: str = ""):
    conn = None
    cursor = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        if district:
            query = """
                SELECT 
                    CAST(e.eczane_id AS CHAR) AS id, 
                    e.eczane_ad AS name, 
                    e.telefon AS phone, 
                    e.latitude, 
                    e.longitude, 
                    CONCAT(a.il, ' / ', a.ilce) AS address,
                    1 AS isOpenOnDuty
                FROM eczane e
                JOIN adres a ON e.adres_id = a.adres_id
                JOIN pharmacy_duty_schedule pds ON e.eczane_id = pds.eczane_id 
                WHERE a.il COLLATE utf8mb4_turkish_ci LIKE %s 
                  AND a.ilce COLLATE utf8mb4_turkish_ci LIKE %s
                GROUP BY e.eczane_id
            """
            cursor.execute(query, (f"%{city}%", f"%{district}%"))
        else:
            query = """
                SELECT 
                    CAST(e.eczane_id AS CHAR) AS id, 
                    e.eczane_ad AS name, 
                    e.telefon AS phone, 
                    e.latitude, 
                    e.longitude, 
                    CONCAT(a.il, ' / ', a.ilce) AS address,
                    1 AS isOpenOnDuty
                FROM eczane e
                JOIN adres a ON e.adres_id = a.adres_id
                JOIN pharmacy_duty_schedule pds ON e.eczane_id = pds.eczane_id 
                WHERE a.il COLLATE utf8mb4_turkish_ci LIKE %s
                GROUP BY e.eczane_id
            """
            cursor.execute(query, (f"%{city}%",))

        results = cursor.fetchall()
        return {"success": True, "result": results}
    except Exception as e:
        return {"success": False, "message": str(e)}
    finally:
        if cursor: cursor.close()
        if conn: conn.close()
@app.get("/pharmacies/by-location")
def get_pharmacies_by_location(
        lat: float,
        lng: float,
        is_duty: int = 1
):
    conn = None
    cursor = None

    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        # --------------------------------------------------
        # 1. GPS'e en yakın eczanenin il / ilçesini bul
        # --------------------------------------------------

        locate_query = """
            SELECT 
                a.il,
                a.ilce
            FROM eczane e
            INNER JOIN adres a 
                ON e.adres_id = a.adres_id
            WHERE e.latitude IS NOT NULL
              AND e.longitude IS NOT NULL
            ORDER BY 
                POW(e.latitude - %s, 2) +
                POW(e.longitude - %s, 2)
            ASC
            LIMIT 1
        """

        cursor.execute(
            locate_query,
            (lat, lng)
        )

        nearest_address = cursor.fetchone()

        if not nearest_address:
            return {
                "success": True,
                "result": [],
                "message": "Yakın konumda eczane bulunamadı."
            }

        city = nearest_address["il"]
        district = nearest_address["ilce"]

        # --------------------------------------------------
        # 2. TÜM ECZANELER
        # --------------------------------------------------

        if is_duty == 0:

            query = """
                SELECT 
                    CAST(e.eczane_id AS CHAR) AS id,
                    e.eczane_ad AS name,
                    e.telefon AS phone,
                    e.latitude,
                    e.longitude,
                    0 AS isOpenOnDuty,
                    CONCAT(
                        a.il,
                        ' / ',
                        a.ilce
                    ) AS address
                FROM eczane e
                INNER JOIN adres a
                    ON e.adres_id = a.adres_id
                WHERE 
                    a.il = %s
                    AND a.ilce = %s
                ORDER BY
                    POW(e.latitude - %s, 2) +
                    POW(e.longitude - %s, 2)
            """

            cursor.execute(
                query,
                (
                    city,
                    district,
                    lat,
                    lng,
                )
            )

        # --------------------------------------------------
        # 3. SADECE NÖBETÇİ ECZANELER
        # --------------------------------------------------

        else:

            query = """
                SELECT 
                    CAST(e.eczane_id AS CHAR) AS id,
                    e.eczane_ad AS name,
                    e.telefon AS phone,
                    e.latitude,
                    e.longitude,
                    1 AS isOpenOnDuty,
                    CONCAT(
                        a.il,
                        ' / ',
                        a.ilce
                    ) AS address
                FROM eczane e

                INNER JOIN adres a
                    ON e.adres_id = a.adres_id

                INNER JOIN pharmacy_duty_schedule pds
                    ON e.eczane_id = pds.eczane_id

                WHERE 
                    a.il = %s
                    AND a.ilce = %s
                    AND pds.duty_date = CURDATE()

                GROUP BY
                    e.eczane_id

                ORDER BY
                    POW(e.latitude - %s, 2) +
                    POW(e.longitude - %s, 2)
            """

            cursor.execute(
                query,
                (
                    city,
                    district,
                    lat,
                    lng,
                )
            )

        results = cursor.fetchall()

        # --------------------------------------------------
        # DEBUG
        # --------------------------------------------------

        print("========================================")
        print("📍 GPS KONUMU")
        print("Latitude :", lat)
        print("Longitude:", lng)
        print("----------------------------------------")
        print("📍 TESPİT EDİLEN KONUM")
        print("Şehir    :", city)
        print("İlçe     :", district)
        print("----------------------------------------")
        print("Nöbetçi mi:", is_duty)
        print("🏥 BULUNAN ECZANE SAYISI:", len(results))
        print("========================================")

        return {
            "success": True,
            "result": results,
            "detected_location": f"{city} / {district}",
        }

    except Exception as e:

        print("❌ HATA:", str(e))

        return {
            "success": False,
            "message": str(e),
        }

    finally:

        if cursor:
            cursor.close()

        if conn:
            conn.close()


@app.get("/pharmacies/for-cart")
def get_pharmacies_for_cart(
        lat: float,
        lng: float,
        product_ids: list[int] = Query(...),
        quantities: list[int] = Query(...),
):
    conn = None
    cursor = None

    try:

        # =====================================================
        # 0. SEPET KONTROLÜ
        # =====================================================

        if not product_ids:
            return {
                "success": False,
                "message": "Sepette ürün bulunamadı.",
                "result": []
            }

        if not quantities:
            return {
                "success": False,
                "message": "Ürün miktarları bulunamadı.",
                "result": []
            }

        if len(product_ids) != len(quantities):
            return {
                "success": False,
                "message": "Ürün ve miktar bilgileri eşleşmiyor.",
                "result": []
            }

        # =====================================================
        # 1. VERİTABANI BAĞLANTISI
        # =====================================================

        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        # =====================================================
        # 2. GPS KONUMUNA EN YAKIN ECZANENİN
        #    ŞEHİR / İLÇESİNİ BUL
        # =====================================================

        locate_query = """
            SELECT
                a.il,
                a.ilce
            FROM eczane e
            JOIN adres a
                ON e.adres_id = a.adres_id
            WHERE e.latitude IS NOT NULL
              AND e.longitude IS NOT NULL
            ORDER BY
                POW(e.latitude - %s, 2) +
                POW(e.longitude - %s, 2)
            ASC
            LIMIT 1
        """

        cursor.execute(
            locate_query,
            (lat, lng)
        )

        nearest_address = cursor.fetchone()

        if not nearest_address:
            return {
                "success": True,
                "result": [],
                "message": "Konumunuza yakın eczane bulunamadı."
            }

        city = nearest_address["il"]
        district = nearest_address["ilce"]

        # =====================================================
        # 3. SEPETTEKİ ÜRÜNLERİN STOK KOŞULLARINI OLUŞTUR
        #
        # Örnek:
        #
        # Parol >= 2
        # Aferin >= 3
        #
        # =====================================================

        stock_conditions = []
        stock_params = []

        for product_id, quantity in zip(
                product_ids,
                quantities
        ):

            stock_conditions.append(
                "(ei.ilac_id = %s AND ei.stok_miktari >= %s)"
            )

            stock_params.extend([
                product_id,
                quantity
            ])

        stock_condition_sql = " OR ".join(
            stock_conditions
        )

        # =====================================================
        # 4. SEPETTEKİ TÜM ÜRÜNLERİ BULUNDURAN ECZANELERİ BUL
        # =====================================================

        query = f"""
            SELECT

                CAST(e.eczane_id AS CHAR) AS id,

                e.eczane_ad AS name,

                e.telefon AS phone,

                e.latitude,

                e.longitude,

                a.il AS city,

                a.ilce AS district,

                CONCAT(
                    a.il,
                    ' / ',
                    a.ilce,
                    ' / ',
                    a.mahalle,
                    ' / ',
                    a.cadde_sokak,
                    ' No:',
                    a.kapi_no
                ) AS address,

                ROUND(
                    6371 * ACOS(
                        LEAST(
                            1,
                            GREATEST(
                                -1,
                                COS(RADIANS(%s))
                                *
                                COS(RADIANS(e.latitude))
                                *
                                COS(
                                    RADIANS(e.longitude)
                                    -
                                    RADIANS(%s)
                                )
                                +
                                SIN(RADIANS(%s))
                                *
                                SIN(RADIANS(e.latitude))
                            )
                        )
                    ),
                    2
                ) AS distance_km,

                COUNT(DISTINCT ei.ilac_id)
                    AS matched_products

            FROM eczane e

            JOIN adres a
                ON e.adres_id = a.adres_id

            JOIN eczane_ilac ei
                ON e.eczane_id = ei.eczane_id

            WHERE
                (
                    {stock_condition_sql}
                )

            GROUP BY

                e.eczane_id,
                e.eczane_ad,
                e.telefon,
                e.latitude,
                e.longitude,

                a.il,
                a.ilce,
                a.mahalle,
                a.cadde_sokak,
                a.kapi_no

            HAVING
                COUNT(DISTINCT ei.ilac_id) = %s

            ORDER BY

                CASE
                    WHEN
                        TRIM(LOWER(a.il))
                        =
                        TRIM(LOWER(%s))

                    AND

                        TRIM(LOWER(a.ilce))
                        =
                        TRIM(LOWER(%s))

                    THEN 0

                    ELSE 1
                END,

                distance_km ASC
        """

        # =====================================================
        # SQL PARAMETRELERİ
        # =====================================================

        params = [
            lat,
            lng,
            lat,

            *stock_params,

            len(product_ids),

            city,
            district
        ]

        cursor.execute(
            query,
            params
        )

        results = cursor.fetchall()

        # =====================================================
        # 5. BULUNAN ECZANELERİN ID'LERİNİ AL
        # =====================================================

        pharmacy_ids = [
            int(pharmacy["id"])
            for pharmacy in results
        ]

        stock_data = {}

        # =====================================================
        # 6. HER ECZANENİN SEPET ÜRÜNLERİ İÇİN
        #    STOK BİLGİLERİNİ GETİR
        # =====================================================

        if pharmacy_ids:

            pharmacy_placeholders = ",".join(
                ["%s"] * len(pharmacy_ids)
            )

            product_placeholders = ",".join(
                ["%s"] * len(product_ids)
            )

            stock_query = f"""
                SELECT

                    ei.eczane_id,

                    ei.ilac_id,

                    i.ilac_ad,

                    ei.stok_miktari

                FROM eczane_ilac ei

                JOIN ilac i
                    ON ei.ilac_id = i.ilac_id

                WHERE

                    ei.eczane_id IN (
                        {pharmacy_placeholders}
                    )

                    AND

                    ei.ilac_id IN (
                        {product_placeholders}
                    )
            """

            cursor.execute(
                stock_query,
                pharmacy_ids + product_ids
            )

            stock_rows = cursor.fetchall()

            # =================================================
            # STOKLARI ECZANE ID'SİNE GÖRE GRUPLA
            # =================================================

            for row in stock_rows:

                pharmacy_id = row["eczane_id"]

                if pharmacy_id not in stock_data:

                    stock_data[pharmacy_id] = []

                stock_data[pharmacy_id].append({

                    "product_id": row["ilac_id"],

                    "product_name": row["ilac_ad"],

                    "stock": row["stok_miktari"]

                })

        # =====================================================
        # 7. STOK BİLGİLERİNİ ECZANE SONUÇLARINA EKLE
        # =====================================================

        for pharmacy in results:

            pharmacy_id = int(
                pharmacy["id"]
            )

            pharmacy["stocks"] = stock_data.get(
                pharmacy_id,
                []
            )

        # =====================================================
        # 8. DEBUG
        # =====================================================

        print("========================================")
        print("🛒 SEPET ECZANE ARAMA")
        print("========================================")

        print("📍 GPS")
        print("Latitude :", lat)
        print("Longitude:", lng)

        print("----------------------------------------")

        print("📍 TESPİT EDİLEN KONUM")
        print("Şehir    :", city)
        print("İlçe     :", district)

        print("----------------------------------------")

        print("🛒 ÜRÜNLER:")

        for product_id, quantity in zip(
                product_ids,
                quantities
        ):

            print(
                f"Ürün ID: {product_id} "
                f"| Miktar: {quantity}"
            )

        print("----------------------------------------")

        print(
            "🏥 UYGUN ECZANE SAYISI:",
            len(results)
        )

        # =====================================================
        # ECZANELERİ VE STOKLARI YAZDIR
        # =====================================================

        for pharmacy in results:

            print(
                f"🏥 {pharmacy['name']} "
                f"| {pharmacy['city']} / "
                f"{pharmacy['district']} "
                f"| {pharmacy['distance_km']} km"
            )

            for stock in pharmacy["stocks"]:

                print(
                    f"   💊 {stock['product_name']} "
                    f"→ {stock['stock']} adet"
                )

        print("========================================")

        # =====================================================
        # 9. RESPONSE
        # =====================================================

        return {

            "success": True,

            "detected_location": {
                "city": city,
                "district": district
            },

            "product_ids": product_ids,

            "quantities": quantities,

            "result": results
        }

    # =========================================================
    # HATA
    # =========================================================

    except Exception as e:

        print(
            "❌ SEPET ECZANE HATASI:",
            str(e)
        )

        return {

            "success": False,

            "message": str(e),

            "result": []
        }

    # =========================================================
    # BAĞLANTIYI KAPAT
    # =========================================================

    finally:

        if cursor:
            cursor.close()

        if conn:
            conn.close()
# Eczaneye gelen siparişleri listeleme
@app.get("/pharmacies/{eczane_id}/orders")
def get_pharmacy_orders(eczane_id: int):
    conn = None
    cursor = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        query = """
            SELECT 
                CAST(o.order_id AS CHAR) AS id, 
                o.total_amount, 
                o.status, 
                o.created_at,
                o.hasta_tckn AS user_id
            FROM orders o
            WHERE o.eczane_id = %s
            ORDER BY o.created_at DESC
        """
        cursor.execute(query, (eczane_id,))
        results = cursor.fetchall()
        return {"success": True, "result": results}
    except Exception as e:
        return {"success": False, "message": str(e)}
    finally:
        if cursor: cursor.close()
        if conn: conn.close()

# Sipariş durumunu güncelleme (Hazırlanıyor, Yola Çıktı vb.)
class UpdateOrderStatusRequest(BaseModel):
    status: str

@app.put("/orders/{order_id}/status")
def update_order_status(order_id: int, request: UpdateOrderStatusRequest):
    conn = None
    cursor = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        query = "UPDATE orders SET status = %s WHERE order_id = %s"
        cursor.execute(query, (request.status, order_id))
        conn.commit()
        return {"success": True, "message": "Sipariş durumu güncellendi."}
    except Exception as e:
        if conn: conn.rollback()
        return {"success": False, "message": str(e)}
    finally:
        if cursor: cursor.close()
        if conn: conn.close()
# 5. Giriş Yap Endpoint'i
@app.post("/auth/login")
def login(request: LoginRequest):
    conn = None
    cursor = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        query = """
        SELECT
            hasta_tckn AS id,
            hasta_ad_soyad AS name,
            email
        FROM hasta
        WHERE email=%s AND password=%s
        """
        cursor.execute(query, (request.email, request.password))
        user = cursor.fetchone()

        if user is None:
            raise HTTPException(
                status_code=401,
                detail="E-posta veya şifre hatalı."
            )

        return {
            "success": True,
            "result": {
                "id": str(user["id"]),
                "email": user["email"],
                "name": user["name"]
            }
        }
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        if cursor: cursor.close()
        if conn: conn.close()

# 6. İlacın Bulunduğu Eczaneler
@app.get("/products/{product_id}/available-pharmacies")
def get_available_pharmacies_for_product(product_id: int):
    conn = None
    cursor = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        query = """
            SELECT 
                e.eczane_id AS id, 
                e.eczane_ad AS name, 
                e.telefon AS phone, 
                e.latitude, 
                e.longitude, 
                CONCAT(a.il, ' / ', a.ilce, ' - ', a.mahalle) AS address,
                ei.stok_miktari AS stock,
                1 AS isOpenOnDuty
            FROM eczane e
            JOIN eczane_ilac ei ON e.eczane_id = ei.eczane_id
            LEFT JOIN adres a ON e.adres_id = a.adres_id
            LEFT JOIN pharmacy_duty_schedule pds ON e.eczane_id = pds.eczane_id AND pds.duty_date = CURDATE()
            WHERE ei.ilac_id = %s AND ei.stok_miktari > 0
        """
        cursor.execute(query, (product_id,))
        results = cursor.fetchall()

        return {"success": True, "result": results}
    except Exception as e:
        return {"success": False, "message": str(e)}
    finally:
        if cursor: cursor.close()
        if conn: conn.close()

# 7. Tüm Siparişleri Listeleme (GET /orders)
@app.post("/orders")
def create_order(order: OrderRequest):
    conn = None
    cursor = None

    try:
        print()
        print("========================================")
        print("🛒 BACKEND - SİPARİŞ OLUŞTURMA")
        print("========================================")
        print("➡️ MYSQL'E GÖNDERİLEN TCKN:", order.user_id)
        print("➡️ ECZANE ID:", order.eczane_id)
        print("➡️ TOPLAM:", order.total_amount)
        print("➡️ ÜRÜNLER:", order.items)
        print("========================================")

        conn = get_db_connection()
        cursor = conn.cursor()

        # ==========================================
        # 1. HASTA KONTROLÜ
        # ==========================================

        check_patient_query = """
            SELECT hasta_tckn
            FROM hasta
            WHERE hasta_tckn = %s
        """

        cursor.execute(
            check_patient_query,
            (order.user_id,)
        )

        patient = cursor.fetchone()

        if not patient:
            return {
                "success": False,
                "message": f"Hasta bulunamadı. TCKN: {order.user_id}"
            }

        # ==========================================
        # 2. ECZANE KONTROLÜ
        # ==========================================

        check_pharmacy_query = """
            SELECT eczane_id
            FROM eczane
            WHERE eczane_id = %s
        """

        cursor.execute(
            check_pharmacy_query,
            (order.eczane_id,)
        )

        pharmacy = cursor.fetchone()

        if not pharmacy:
            return {
                "success": False,
                "message": f"Eczane bulunamadı. ID: {order.eczane_id}"
            }

        # ==========================================
        # 3. SİPARİŞİ OLUŞTUR
        # ==========================================

        order_query = """
            INSERT INTO orders (
                hasta_tckn,
                eczane_id,
                total_amount,
                status
            )
            VALUES (%s, %s, %s, 'Pending')
        """

        cursor.execute(
            order_query,
            (
                order.user_id,
                order.eczane_id,
                order.total_amount
            )
        )

        order_id = cursor.lastrowid

        # ==========================================
        # 4. SİPARİŞ ÜRÜNLERİNİ EKLE
        # ==========================================

        for item in order.items:

            price_query = """
                SELECT satis_fiyat
                FROM ilac
                WHERE ilac_id = %s
            """

            cursor.execute(
                price_query,
                (item.product_id,)
            )

            product = cursor.fetchone()

            if not product:
                raise Exception(
                    f"Ürün bulunamadı. İlaç ID: {item.product_id}"
                )

            unit_price = product[0]

            item_query = """
                INSERT INTO order_items (
                    order_id,
                    ilac_id,
                    quantity,
                    unit_price
                )
                VALUES (%s, %s, %s, %s)
            """

            cursor.execute(
                item_query,
                (
                    order_id,
                    item.product_id,
                    item.quantity,
                    unit_price
                )
            )

        # ==========================================
        # 5. KAYDET
        # ==========================================

        conn.commit()

        print("✅ SİPARİŞ BAŞARIYLA OLUŞTURULDU")
        print("🆔 ORDER ID:", order_id)

        return {
            "success": True,
            "message": "Sipariş başarıyla oluşturuldu",
            "order_id": order_id
        }

    except Exception as e:

        if conn:
            conn.rollback()

        print("❌ SİPARİŞ OLUŞTURMA HATASI:", str(e))

        return {
            "success": False,
            "message": str(e)
        }

    finally:

        if cursor:
            cursor.close()

        if conn:
            conn.close()
@app.get("/orders")
def get_orders(user_id: str):
    conn = None
    cursor = None

    try:
        print()
        print("========================================")
        print("📦 KULLANICININ SİPARİŞLERİ")
        print("========================================")
        print("👤 USER ID / TCKN:", user_id)

        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        query = """
            SELECT
                CAST(o.order_id AS CHAR) AS id,
                o.hasta_tckn,
                o.eczane_id,
                e.eczane_ad AS pharmacy_name,
                o.total_amount,
                o.status,
                o.created_at,
                CONCAT(
                    a.il,
                    ' / ',
                    a.ilce
                ) AS address
            FROM orders o

            JOIN eczane e
                ON o.eczane_id = e.eczane_id

            LEFT JOIN adres a
                ON e.adres_id = a.adres_id

            WHERE o.hasta_tckn = %s

            ORDER BY o.created_at DESC
        """

        cursor.execute(
            query,
            (user_id,)
        )

        orders = cursor.fetchall()

        print("📦 BULUNAN SİPARİŞ SAYISI:", len(orders))
        print("========================================")

        return {
            "success": True,
            "result": orders
        }

    except Exception as e:

        print(
            "❌ SİPARİŞLERİ GETİRME HATASI:",
            str(e)
        )

        return {
            "success": False,
            "message": str(e),
            "result": []
        }

    finally:

        if cursor:
            cursor.close()

        if conn:
            conn.close()
# 9. Sipariş Detay Endpoint'i
@app.get("/orders/{order_id}")
def get_order_detail(order_id: int):
    conn = None
    cursor = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        # Sipariş üst bilgileri
        order_query = """
            SELECT 
                CAST(o.order_id AS CHAR) AS id, 
                o.total_amount, 
                o.status, 
                o.created_at, 
                CONCAT(a.il, ' / ', a.ilce) AS address,
                e.eczane_ad AS pharmacy_name
            FROM orders o
            JOIN eczane e ON o.eczane_id = e.eczane_id
            LEFT JOIN adres a ON e.adres_id = a.adres_id
            WHERE o.order_id = %s
        """
        cursor.execute(order_query, (order_id,))
        order = cursor.fetchone()

        if not order:
            return {"success": False, "message": "Sipariş bulunamadı."}

        # Siparişe ait ürünleri çekiyoruz
        items_query = """
            SELECT 
                oi.ilac_id AS product_id,
                i.ilac_ad AS product_name,
                oi.quantity,
                oi.unit_price
            FROM order_items oi
            JOIN ilac i ON oi.ilac_id = i.ilac_id
            WHERE oi.order_id = %s
        """
        cursor.execute(items_query, (order_id,))
        items = cursor.fetchall()

        order["items"] = items

        return {"success": True, "result": order}
    except Exception as e:
        return {"success": False, "message": str(e)}
    finally:
        if cursor: cursor.close()
        if conn: conn.close()


# 1. Kullanıcının Favorilerini Listeleme Endpoint'i

class ToggleProductFavoriteRequest(BaseModel):
    user_id: str      # hasta_tckn
    item_id: str | int # Ürün ID'si (ilac_id)

# 1. Kullanıcının Favori Ürünlerini Listeleme
# 1. Kullanıcının Favori Ürünlerini Listeleme
@app.get("/favorites/{user_id}")
def get_favorites(user_id: str):
    conn = None
    cursor = None

    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        query = """
            SELECT 
                CAST(i.ilac_id AS CHAR) AS id,
                i.ilac_ad AS title,
                'product' AS type
            FROM favorite_products fp
            JOIN ilac i ON fp.ilac_id = i.ilac_id
            WHERE CAST(fp.hasta_tckn AS CHAR) = %s
        """

        cursor.execute(query, (user_id,))
        results = cursor.fetchall()

        print("FAVORİLER:", results)

        return {
            "success": True,
            "result": results
        }

    except Exception as e:
        print("FAVORİLER GETİRME HATASI:", str(e))

        return {
            "success": False,
            "message": str(e)
        }

    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()

# 2. Ürün Favori Ekle / Çıkar (Toggle)
@app.post("/favorites/toggle")
def toggle_favorite(request: ToggleProductFavoriteRequest):
    conn = None
    cursor = None
    try:
        product_id = int(request.item_id)

        conn = get_db_connection()
        cursor = conn.cursor()

        # Kayıt var mı kontrol et
        check_query = "SELECT favorite_id FROM favorite_products WHERE hasta_tckn = %s AND ilac_id = %s"
        cursor.execute(check_query, (request.user_id, product_id))
        exists = cursor.fetchone()

        if exists:
            delete_query = "DELETE FROM favorite_products WHERE hasta_tckn = %s AND ilac_id = %s"
            cursor.execute(delete_query, (request.user_id, product_id))
            message = "Ürün favorilerden çıkarıldı."
        else:
            insert_query = "INSERT INTO favorite_products (hasta_tckn, ilac_id) VALUES (%s, %s)"
            cursor.execute(insert_query, (request.user_id, product_id))
            message = "Ürün favorilere eklendi."

        conn.commit()
        return {"success": True, "message": message}
    except Exception as e:
        if conn: conn.rollback()
        return {"success": False, "message": str(e)}
    finally:
        if cursor: cursor.close()
        if conn: conn.close()
if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="127.0.0.1", port=8000, reload=True)