# Color Swap Feature - API Documentation

## Overview
Tài liệu này mô tả các API endpoints cần thiết để hỗ trợ tính năng Color Swap trong ứng dụng Paint Color Swap. Tính năng cho phép người dùng tải ảnh lên, chọn màu sơn, và thêm sản phẩm vào giỏ hàng.

## Base URL
```
https://api.paintcolorswap.com/v1
```

## Authentication
Tất cả các endpoints đều yêu cầu JWT token trong header:
```
Authorization: Bearer <jwt_token>
```

---

## 1. Image Processing APIs

### 1.1 Upload Image
**Endpoint:** `POST /images/upload`

**Description:** Upload ảnh phòng của khách hàng để xử lý color swap

**Request:**
```http
POST /images/upload
Content-Type: multipart/form-data
Authorization: Bearer <jwt_token>

{
  "image": <file>,
  "room_type": "living_room" | "bedroom" | "kitchen" | "bathroom",
  "description": "Optional description"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "image_id": "img_123456789",
    "original_url": "https://storage.example.com/images/original/img_123456789.jpg",
    "thumbnail_url": "https://storage.example.com/images/thumbnails/img_123456789.jpg",
    "upload_time": "2024-01-15T10:30:00Z",
    "file_size": 2048576,
    "dimensions": {
      "width": 1920,
      "height": 1080
    }
  }
}
```

### 1.2 Apply Color to Image
**Endpoint:** `POST /images/{image_id}/apply-color`

**Description:** Áp dụng màu sơn lên vùng được chọn trong ảnh

**Request:**
```http
POST /images/img_123456789/apply-color
Content-Type: application/json
Authorization: Bearer <jwt_token>

{
  "color_code": "#FFE4B5",
  "color_name": "Moccasin",
  "region": {
    "type": "polygon",
    "coordinates": [
      {"x": 100, "y": 150},
      {"x": 800, "y": 150},
      {"x": 800, "y": 600},
      {"x": 100, "y": 600}
    ]
  },
  "surface_type": "wall",
  "blend_mode": "normal",
  "opacity": 0.8
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "processed_image_id": "proc_123456789",
    "processed_url": "https://storage.example.com/images/processed/proc_123456789.jpg",
    "thumbnail_url": "https://storage.example.com/images/processed/thumbnails/proc_123456789.jpg",
    "processing_time": 3.2,
    "applied_color": {
      "color_code": "#FFE4B5",
      "color_name": "Moccasin",
      "product_id": "paint_001"
    }
  }
}
```

---

## 2. Paint Product APIs

### 2.1 Get Paint Colors
**Endpoint:** `GET /products/paint-colors`

**Description:** Lấy danh sách màu sơn có sẵn

**Query Parameters:**
- `category`: interior | exterior (optional)
- `brand`: brand name (optional)
- `page`: page number (default: 1)
- `limit`: items per page (default: 50)

**Response:**
```json
{
  "success": true,
  "data": {
    "colors": [
      {
        "color_id": "color_001",
        "name": "Trắng",
        "color_code": "#FFFFFF",
        "rgb": {"r": 255, "g": 255, "b": 255},
        "category": "interior",
        "brand": "Dulux",
        "product_id": "paint_001",
        "price": 250000,
        "currency": "VND",
        "coverage": "12-15 m²/lít",
        "finish": "matte" | "satin" | "gloss"
      }
    ],
    "pagination": {
      "current_page": 1,
      "total_pages": 5,
      "total_items": 240,
      "items_per_page": 50
    }
  }
}
```

---

## 3. Shopping Cart APIs

### 3.1 Add to Cart
**Endpoint:** `POST /cart/items`

**Description:** Thêm sản phẩm sơn vào giỏ hàng

**Request:**
```http
POST /cart/items
Content-Type: application/json
Authorization: Bearer <jwt_token>

{
  "product_id": "paint_001",
  "color_id": "color_002",
  "quantity": 2,
  "surface_type": "wall",
  "room_reference": {
    "image_id": "img_123456789",
    "processed_image_id": "proc_123456789"
  },
  "notes": "Cho phòng khách"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "cart_item_id": "cart_item_001",
    "product": {
      "product_id": "paint_001",
      "name": "Sơn Nội Thất Cao Cấp",
      "brand": "Dulux"
    },
    "color": {
      "color_id": "color_002",
      "name": "Xanh Nhạt",
      "color_code": "#87CEEB"
    },
    "quantity": 2,
    "unit_price": 275000,
    "total_price": 550000,
    "currency": "VND",
    "added_at": "2024-01-15T10:45:00Z"
  }
}
```

---

## 4. Image Sharing APIs

### 4.1 Generate Share Link
**Endpoint:** `POST /images/{processed_image_id}/share`

**Description:** Tạo link chia sẻ cho ảnh đã xử lý

**Request:**
```http
POST /images/proc_123456789/share
Content-Type: application/json
Authorization: Bearer <jwt_token>

{
  "share_type": "public" | "private",
  "expiry_days": 30,
  "include_product_info": true
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "share_id": "share_123456",
    "share_url": "https://paintcolorswap.com/shared/share_123456",
    "qr_code_url": "https://api.paintcolorswap.com/qr/share_123456.png",
    "expires_at": "2024-02-14T10:45:00Z",
    "view_count": 0,
    "created_at": "2024-01-15T10:45:00Z"
  }
}
```

### 4.2 Save Processed Image
**Endpoint:** `POST /images/{processed_image_id}/save`

**Description:** Lưu ảnh đã xử lý vào thư viện cá nhân

**Request:**
```http
POST /images/proc_123456789/save
Content-Type: application/json
Authorization: Bearer <jwt_token>

{
  "album_name": "Phòng khách",
  "description": "Thử màu xanh nhạt cho tường phòng khách"
}
```

---

## 5. Technical Requirements

### Image Processing
- **Supported formats:** JPEG, PNG, HEIC
- **Max file size:** 10MB
- **Max dimensions:** 4096x4096 pixels
- **Processing timeout:** 30 seconds
- **Storage:** AWS S3 or equivalent cloud storage

### Performance Requirements
- **API response time:** < 500ms (95th percentile)
- **Image upload:** < 5 seconds
- **Color processing:** < 10 seconds
- **Concurrent users:** Support 1000+ concurrent requests

### Security
- **Authentication:** JWT tokens with 24h expiry
- **File validation:** Strict image format validation
- **Rate limiting:** 100 requests/minute per user
- **Data encryption:** All data encrypted at rest and in transit

---

**Document Version:** 1.0  
**Last Updated:** January 15, 2024  
**Contact:** backend-team@paintcolorswap.com 