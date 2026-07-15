import cv2
import mediapipe as mp
import time
import math


# -----------------------------
# Load MediaPipe Face Landmarker
# -----------------------------

from mediapipe.tasks import python
from mediapipe.tasks.python import vision


model_path = "face_landmarker.task"


base_options = python.BaseOptions(
    model_asset_path=model_path
)


options = vision.FaceLandmarkerOptions(
    base_options=base_options,
    num_faces=1
)


detector = vision.FaceLandmarker.create_from_options(options)


# -----------------------------
# Eye landmark indexes
# -----------------------------

LEFT_EYE = [
    33, 160, 158,
    133, 153, 144
]

RIGHT_EYE = [
    362, 385, 387,
    263, 373, 380
]


# -----------------------------
# Calculate Eye Aspect Ratio
# -----------------------------

def calculate_ear(landmarks, eye_points):

    p1 = landmarks[eye_points[0]]
    p2 = landmarks[eye_points[1]]
    p3 = landmarks[eye_points[2]]
    p4 = landmarks[eye_points[3]]
    p5 = landmarks[eye_points[4]]
    p6 = landmarks[eye_points[5]]

    vertical1 = math.dist(
        (p2.x, p2.y),
        (p6.x, p6.y)
    )

    vertical2 = math.dist(
        (p3.x, p3.y),
        (p5.x, p5.y)
    )

    horizontal = math.dist(
        (p1.x, p1.y),
        (p4.x, p4.y)
    )

    return (vertical1 + vertical2) / (2 * horizontal)



# -----------------------------
# Camera setup
# -----------------------------

camera = cv2.VideoCapture(0)


closed_start = None
drowsy = False


while True:

    ret, frame = camera.read()

    if not ret:
        print("Cannot open camera")
        break


    # Convert BGR -> RGB
    rgb = cv2.cvtColor(
        frame,
        cv2.COLOR_BGR2RGB
    )


    mp_image = mp.Image(
        image_format=mp.ImageFormat.SRGB,
        data=rgb
    )


    # Run AI model
    result = detector.detect(mp_image)



    # -----------------------------
    # Drowsiness detection
    # -----------------------------

    if result.face_landmarks:

        face = result.face_landmarks[0]


        left_ear = calculate_ear(
            face,
            LEFT_EYE
        )

        right_ear = calculate_ear(
            face,
            RIGHT_EYE
        )


        ear = (
            left_ear +
            right_ear
        ) / 2



        # Eye closed
        if ear < 0.21:


            if closed_start is None:
                closed_start = time.time()


            elapsed = (
                time.time()
                -
                closed_start
            )


            if elapsed > 2:
                drowsy = True



        else:

            closed_start = None
            drowsy = False



        # Show EAR value
        cv2.putText(
            frame,
            f"EAR: {ear:.2f}",
            (20, 100),
            cv2.FONT_HERSHEY_SIMPLEX,
            0.8,
            (255,255,255),
            2
        )



    # -----------------------------
    # Display status
    # -----------------------------

    if drowsy:

        cv2.putText(
            frame,
            "DROWSY!",
            (40, 60),
            cv2.FONT_HERSHEY_SIMPLEX,
            2,
            (0,0,255),
            4
        )


    else:

        cv2.putText(
            frame,
            "ALERT",
            (40,60),
            cv2.FONT_HERSHEY_SIMPLEX,
            2,
            (0,255,0),
            4
        )


    cv2.imshow(
        "Vigil",
        frame
    )


    # press q to quit
    if cv2.waitKey(1) & 0xFF == ord("q"):
        break



camera.release()
cv2.destroyAllWindows()