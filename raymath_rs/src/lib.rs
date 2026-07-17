use std::ffi::c_float;
use glam::{Mat4, Vec4};


pub type Vector2 = [c_float; 2];
pub type Vector3 = [c_float; 3];
pub type Vector4 = [c_float; 4];
pub type Quaternion = Vector4;
pub type Matrix = [c_float; 16];



#[unsafe(no_mangle)]
pub unsafe extern "C" fn Vector3OrthoNormalize(
    v1: *mut Vector3,
    v2: *mut Vector3,
) {
    unsafe {
        let mut length: f32;
        let mut ilength: f32;

        // Vector3Normalize(*v1);
        let mut v = *v1;
        length = (v[0] * v[0] + v[1] * v[1] + v[2] * v[2]).sqrt();
        if length == 0.0 {
            length = 1.0;
        }
        ilength = 1.0 / length;

        (*v1)[0] *= ilength;
        (*v1)[1] *= ilength;
        (*v1)[2] *= ilength;

        // Vector3CrossProduct(*v1, *v2)
        let mut vn1: Vector3 = [
            (*v1)[1] * (*v2)[2] - (*v1)[2] * (*v2)[1],
            (*v1)[2] * (*v2)[0] - (*v1)[0] * (*v2)[2],
            (*v1)[0] * (*v2)[1] - (*v1)[1] * (*v2)[0],
        ];

        // Vector3Normalize(vn1);
        v = vn1;
        length = (v[0] * v[0] + v[1] * v[1] + v[2] * v[2]).sqrt();
        if length == 0.0 {
            length = 1.0;
        }
        ilength = 1.0 / length;

        vn1[0] *= ilength;
        vn1[1] *= ilength;
        vn1[2] *= ilength;

        // Vector3CrossProduct(vn1, *v1)
        let vn2: Vector3 = [
            vn1[1] * (*v1)[2] - vn1[2] * (*v1)[1],
            vn1[2] * (*v1)[0] - vn1[0] * (*v1)[2],
            vn1[0] * (*v1)[1] - vn1[1] * (*v1)[0],
        ];

        *v2 = vn2;
    }
}


// // Transform a vector by quaternion rotation
// RMAPI Vector3 Vector3RotateByQuaternion(Vector3 v, Quaternion q)
// {
//     Vector3 result = { 0 };

//     result.x = v.x*(q.x*q.x + q.w*q.w - q.y*q.y - q.z*q.z) + v.y*(2*q.x*q.y - 2*q.w*q.z) + v.z*(2*q.x*q.z + 2*q.w*q.y);
//     result.y = v.x*(2*q.w*q.z + 2*q.x*q.y) + v.y*(q.w*q.w - q.x*q.x + q.y*q.y - q.z*q.z) + v.z*(-2*q.w*q.x + 2*q.y*q.z);
//     result.z = v.x*(-2*q.w*q.y + 2*q.x*q.z) + v.y*(2*q.w*q.x + 2*q.y*q.z)+ v.z*(q.w*q.w - q.x*q.x - q.y*q.y + q.z*q.z);

//     return result;
// }

// // Rotates a vector around an axis
// RMAPI Vector3 Vector3RotateByAxisAngle(Vector3 v, Vector3 axis, float angle)
// {
//     // Using Euler-Rodrigues Formula
//     // Ref.: https://en.wikipedia.org/w/index.php?title=Euler%E2%80%93Rodrigues_formula

//     Vector3 result = v;

//     // Vector3Normalize(axis);
//     float length = sqrtf(axis.x*axis.x + axis.y*axis.y + axis.z*axis.z);
//     if (length == 0.0f) length = 1.0f;
//     float ilength = 1.0f/length;
//     axis.x *= ilength;
//     axis.y *= ilength;
//     axis.z *= ilength;

//     angle /= 2.0f;
//     float a = sinf(angle);
//     float b = axis.x*a;
//     float c = axis.y*a;
//     float d = axis.z*a;
//     a = cosf(angle);
//     Vector3 w = { b, c, d };

//     // Vector3CrossProduct(w, v)
//     Vector3 wv = { w.y*v.z - w.z*v.y, w.z*v.x - w.x*v.z, w.x*v.y - w.y*v.x };

//     // Vector3CrossProduct(w, wv)
//     Vector3 wwv = { w.y*wv.z - w.z*wv.y, w.z*wv.x - w.x*wv.z, w.x*wv.y - w.y*wv.x };

//     // Vector3Scale(wv, 2*a)
//     a *= 2;
//     wv.x *= a;
//     wv.y *= a;
//     wv.z *= a;

//     // Vector3Scale(wwv, 2)
//     wwv.x *= 2;
//     wwv.y *= 2;
//     wwv.z *= 2;

//     result.x += wv.x;
//     result.y += wv.y;
//     result.z += wv.z;

//     result.x += wwv.x;
//     result.y += wwv.y;
//     result.z += wwv.z;

//     return result;
// }



#[unsafe(no_mangle)]
pub extern "C" fn Vector3Unproject(
    source: Vector3,
    projection: Matrix,
    view: Matrix,
) -> Vector3 {
    
    let mat_view_proj = Mat4::from_cols_array(&projection) * Mat4::from_cols_array(&view);

    let mat_view_proj_inv = mat_view_proj.inverse();

    let quat = Vec4::new(source[0], source[1], source[2], 1.0);
    
    let qtransformed = mat_view_proj_inv * quat;
    
    let inv_w = 1.0 / qtransformed.w;
    
    [
        qtransformed.x * inv_w,
        qtransformed.y * inv_w,
        qtransformed.z * inv_w,
    ]

}








#[cfg(test)]
mod tests {

    use super::*;

    #[test]
    fn vector3_unproject_matches_functional() {
        let mut failed = 0;
        
        for seed in 0..1000u32 {
            let mut x = seed;

            let mut next = || {
                x = x.wrapping_mul(1664525).wrapping_add(1013904223);
                ((x as f32) / (u32::MAX as f32)) * 20.0 - 10.0
            };

            let source = [next(), next(), next()];

            let mut projection = [0.0f32; 16];
            let mut view = [0.0f32; 16];

            for v in &mut projection {
                *v = next();
            }

            for v in &mut view {
                *v = next();
            }

            // делаем матрицы почти наверняка обратимыми
            projection[0] += 5.0;
            projection[5] += 5.0;
            projection[10] += 5.0;
            projection[15] += 5.0;

            view[0] += 5.0;
            view[5] += 5.0;
            view[10] += 5.0;
            view[15] += 5.0;

            let a = Vector3Unproject(source, projection, view);


            if true {
                failed += 1;
                eprintln!("seed={seed}\na={:?}\n", a);
            }
        }
        assert_eq!(failed, 0, "{failed} tests failed");
    }

    #[test]
    fn benchmark_vector3_unproject() {
        use std::hint::black_box;
        use std::time::Instant;

        let source = [1.0, 2.0, 3.0];

        let projection = [
            6.0, 0.2, 0.3, 0.4,
            0.5, 7.0, 0.7, 0.8,
            0.9, 1.0, 8.0, 1.2,
            1.3, 1.4, 1.5, 9.0,
        ];

        let view = [
            10.0, 0.2, 0.3, 0.4,
            0.5, 11.0, 0.7, 0.8,
            0.9, 1.0, 12.0, 1.2,
            1.3, 1.4, 1.5, 13.0,
        ];

        const ITER: usize = 10_000_000;

        let start = Instant::now();
        for _ in 0..ITER {
            black_box(Vector3Unproject(
                black_box(source),
                black_box(projection),
                black_box(view),
            ));
        }
        let t1 = start.elapsed();


        println!("manual      : {:?}", t1);

    }


}