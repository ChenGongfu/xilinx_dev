from moviepy.editor import VideoFileClip
import argparse

parser = argparse.ArgumentParser(description='Convert mp4 to gif')
parser.add_argument('--mp4', type=str, help='Path to the mp4 file')
parser.add_argument('--gif', type=str, help='Path to the gif file')
def convert_to_gif(mp4_file, gif_file):
    clip = VideoFileClip(mp4_file)
    clip.write_gif(gif_file)

if __name__ == '__main__':
    args = parser.parse_args()
    if args.mp4 is None or args.gif is None:
        print('Please provide both mp4 and gif file paths')
    else:
        convert_to_gif(args.mp4, args.gif)
