import fs from "fs";
import path from "path";
import axios from "axios";
import { BUILD_GRADLE } from "./template";

export interface IStepContent {
  poster: string;
  title: string;
  description: string;
}
export interface IStep {
  index: number;
  content: IStepContent;
}

export interface IFakeCallUser {
  icon: string;
  username: string;
  phoneNumber: string;
  audio: string;
  video: string;
}

async function downloadFile(
  url: string,
  outputPath: string,
  query?: string
): Promise<string | null> {
  try {
    let response;
    if (query) {
      response = await axios({
        url,
        method: "GET",
        responseType: "stream",
        params:{
          userId: query 
        }
      });
    } else {
      response = await axios({
        url,
        method: "GET",
        responseType: "stream",
      });
    }

    const writer = fs.createWriteStream(outputPath);
    response.data.pipe(writer);

    return new Promise((resolve, reject) => {
      writer.on("finish", () => resolve(outputPath));
      writer.on("error", reject);
    });
  } catch (error) {
    console.error(`Failed to download file from ${url}:`, error);
    return null;
  }
}

const saveToJson = async ({
  about = "path_to",
  app_icon,
  app_name,
  contact = "contact@email.com",
  content,
  intro,
  main_color,
  privacy = "path_to",
  splash_url,
  terms = "path_to",
}: {
  content: IFakeCallUser[];
  app_name: string;
  app_icon: string;
  splash_url: string;
  main_color: string;
  contact: string;
  about: string;
  privacy: string;
  terms: string;
  intro: IStep[];
}) => {
  const filePath = path.join(__dirname, "..", "assets", "db.json");
  const dbData: {
    content: any[];
    app_name: string;
    app_icon: string;
    splash_url: string;
    main_color: string;
    contact: string;
    about: string;
    privacy: string;
    terms: string;
    intro: any[];
  } = {
    content:content.map(item => ({icon:item.icon,name:item.username,number:item.phoneNumber,vocal:item.audio,video:item.video})),
    app_name,
    app_icon,
    splash_url,
    main_color,
    contact,
    about,
    privacy,
    terms,
    intro:intro.map(i => ({title:i.content.title,description:i.content.description,icon:i.content.poster})),
  };

  try {
    await fs.promises.writeFile(filePath, JSON.stringify(dbData, null, 2));
    console.log("Database saved successfully!");
  } catch (error) {
    console.error("Failed to save database:", error);
  }
};

const downloadAssets = async (content: IFakeCallUser[],userId:string) => {
  const assetsDir = path.join(__dirname, "..", "assets");
  if (!fs.existsSync(assetsDir)) {
    fs.mkdirSync(assetsDir);
  }

  const newContent: IFakeCallUser[] = [];

  const downloadPromises = content.map(async (item) => {
    const iconPath = path.join(assetsDir, item.icon.split("/").pop()!);
    const audioPath = path.join(assetsDir, item.audio.split("/").pop()!);
    const videoPath = path.join(assetsDir, item.video.split("/").pop()!);

    await downloadFile(item.icon, iconPath);
    await downloadFile(item.audio, audioPath,userId);
    await downloadFile(item.video, videoPath,userId);

    newContent.push({
      ...item,
      icon: iconPath.split("/").slice(-2).join("/"),
      audio: audioPath.split("/").slice(-1).join("/"),//TODO: check if this is correct because in db json of mob develepoer he didn't include assets in vocal
      video: videoPath.split("/").slice(-1).join("/"),
    });
  });

  try {
    await Promise.all(downloadPromises);
    console.log("Assets downloaded successfully!");
    return newContent;
  } catch (error) {
    console.error("Failed to download assets:", error);
  }
};
const downloadIntro = async (intro: IStep[]) => {
  const assetsDir = path.join(__dirname, "..", "assets");
  if (!fs.existsSync(assetsDir)) {
    fs.mkdirSync(assetsDir);
  }

  const newIntro: IStep[] = [];

  const downloadPromises = intro.map(async (item) => {
    const iconPath = path.join(assetsDir, item.content.poster.split("/").pop()!);

    await downloadFile(item.content.poster, iconPath);

    newIntro.push({
      index: item.index,
      content:{
        ...item.content,
        poster: iconPath.split("/").slice(-2).join("/")
      },
    });
  });

  try {
    await Promise.all(downloadPromises);
    console.log("Intro posters downloaded successfully!");
    return newIntro;
  } catch (error) {
    console.error("Failed to download Intro posters:", error);
  }
};

function createKeyPropertiesFile({
  keyPassword,
  storeFile,
  storePassword,
  keyAlias,
}: {
  storePassword: string;
  keyPassword: string;
  storeFile: string;
  keyAlias: string;
}) {
  const storePath = path.join(
    __dirname,
    "..",
    "android",
    "app",
    storeFile
  );
  const keyPropertiesContent = `
  storePassword=${storePassword}
  keyPassword=${keyPassword}
  keyAlias=${keyAlias}
  storeFile=${storePath}
  `;

  // Define the path for the key.properties file
  const keyPropertiesFilePath = path.join(
    __dirname,
    "..",
    "android",
    "key.properties"
  );

  // Write the key.properties file
  fs.writeFileSync(keyPropertiesFilePath, keyPropertiesContent.trim(), "utf8");

  console.log(`key.properties file created at ${keyPropertiesFilePath}`);
}

function replaceGradleFile() {
  // Path to the build.gradle file
  const gradleFilePath = path.join(
    __dirname,
    "..",
    "android",
    "app",
    "build.gradle"
  );

  try {
    // Write the new content to the build.gradle file, overwriting the existing file
    fs.writeFileSync(gradleFilePath, BUILD_GRADLE, "utf8");

    console.log(`Replaced build.gradle file at ${gradleFilePath}`);
  } catch (error) {
    console.error(`Failed to replace build.gradle file: ${error}`);
  }
}
const main = async () => {
  const metadata = JSON.parse(process.env.METADATA || "{}");

  const content: IFakeCallUser[] = metadata.content;
  const intro: IStep[] = metadata.intro;
  const about = "https://via.placeholder.com/150";
  const privacy = "https://via.placeholder.com/150";
  const terms = "https://via.placeholder.com/150";
  const contact = "contact@mobtwin.com";
  const app_name = process.env.APP_NAME || "Flutter Fake Call";
  const userId = process.env.USER_ID || "";
  const app_icon = metadata.icon || "https://via.placeholder.com/150";
  const splash_url = metadata.cover || "https://via.placeholder.com/150";
  const main_color = metadata.mainColor || "#000000";

  const keyPassword = process.env.KEY_PASSWORD || "password";
  const storePassword = process.env.KEY_PASSWORD || "password";
  const keyAlias = process.env.KEY_ALIAS || "key";
  const storeFile = process.env.KEYSTORE_FILE || "key-key.jks";

  const downloadedIcon = await downloadFile(
    app_icon,
    path.join(__dirname, "..", "assets", "icons", "icon.png")
  );
  const downloadedSplash = await downloadFile(
    splash_url,
    path.join(__dirname, "..", "assets", splash_url.split("/").pop()!)
  );

  const newContent = await downloadAssets(content,userId);
  const newIntro = await downloadIntro(intro);

  if (!newContent || newContent.length === 0) {
    console.error("Failed to download assets, exiting...");
    return;
  }
  if (!newIntro || newIntro.length === 0) {
    console.error("Failed to download intro assets, exiting...");
    return;
  }

  await saveToJson({
    content: newContent,
    app_name: app_name,
    app_icon: downloadedIcon?.split("/").slice(-3).join("/")||"assets/icons/icon.png",
    splash_url: downloadedSplash?.split("/").slice(-2).join("/")!,
    main_color: main_color,
    contact: contact,
    about: about,
    privacy: privacy,
    terms: terms,
    intro: newIntro,
  });

  createKeyPropertiesFile({ keyAlias, keyPassword, storePassword, storeFile });
  replaceGradleFile();
};

main();
