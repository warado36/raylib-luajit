use std::ffi::c_float;
use glam::{Mat4, Vec4, Vec3, Quat};

#[repr(C)]
#[derive(Clone, Copy)]
pub struct Vector2 {
    x: c_float,
    y: c_float,
}
#[repr(C)]
#[derive(Clone, Copy)]
pub struct Vector3 {
    x: c_float,
    y: c_float,
    z: c_float,
}
#[repr(C)]
#[derive(Clone, Copy)]
pub struct Vector4 {
    x: c_float,
    y: c_float,
    z: c_float,
    w: c_float,
}
pub type Quaternion = Vector4;
#[repr(C)]
#[derive(Clone, Copy)]
pub struct Matrix {
    m: [c_float; 16],
}



#[unsafe(no_mangle)]
pub unsafe extern "C" fn Vector3OrthoNormalize(
    v1: *mut Vector3,
    v2: *mut Vector3,
) {
    unsafe {
        let mut vec1 = Vec3::new((*v1).x, (*v1).y, (*v1).z);
        let vec2 = Vec3::new((*v2).x, (*v2).y, (*v2).z);

        vec1 = vec1.normalize_or_zero();

        let vn2 = vec1.cross(vec2).normalize_or_zero().cross(vec1);

        *v1 = Vector3 { x: vec1.x, y: vec1.y, z: vec1.z };
        *v2 = Vector3 { x: vn2.x, y: vn2.y, z: vn2.z };
    }
}


// #[unsafe(no_mangle)]
// pub extern "C" fn Vector3RotateByQuaternion(
//     v: Vector3,
//     q: Quaternion,
// ) -> Vector3 {

//     let vec = Vec3::from_array(v);
//     let quat = Quat::from_array(q);

//     let result = quat * vec;

//     result
// }

#[unsafe(no_mangle)]
pub extern "C" fn Vector3RotateByAxisAngle(
    v: Vector3,
    axis: Vector3,
    angle: c_float,
) -> Vector3 {
    let vec = Vec3::new(v.x, v.y, v.z);
    let mut axis_vec = Vec3::new(axis.x, axis.y, axis.z);

    let length = axis_vec.length();
    
    if length == 0.0 {
        return v;
    }

    axis_vec /= length;

    let rotation = Quat::from_axis_angle(axis_vec, angle);
    
    let result = rotation * vec;

    Vector3 { x: result.x, y: result.y, z: result.z }
}



// #[unsafe(no_mangle)]
// pub extern "C" fn Vector3Unproject(
//     source: Vector3,
//     projection: Matrix,
//     view: Matrix,
// ) -> Vector3 {
    
//     let mat_view_proj = Mat4::from_cols_array(&projection) * Mat4::from_cols_array(&view);

//     let mat_view_proj_inv = mat_view_proj.inverse();

//     let quat = Vec4::new(source[0], source[1], source[2], 1.0);
    
//     let qtransformed = mat_view_proj_inv * quat;
    
//     let inv_w = 1.0 / qtransformed.w;
    
//     [
//         qtransformed.x * inv_w,
//         qtransformed.y * inv_w,
//         qtransformed.z * inv_w,
//     ]

// }



